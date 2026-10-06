module FactoryBot
  # @api private
  #
  # Everything a run needs for one factory and one list of runtime traits: the
  # build class, the attribute list merged across the parent chain and the
  # traits, the callbacks, the constructor, to_create and the traits in scope.
  # Configuration caches one instance per [factory name, trait names] pair, so
  # the resolution below happens once instead of on every build.
  class CompiledFactory
    attr_reader :factory, :build_class, :attributes, :callbacks, :constructor,
      :to_create, :traits, :evaluator_class

    def self.compile(factory, trait_names)
      Compilation.new(factory, trait_names).result
    end

    def initialize(factory:, build_class:, attributes:, callbacks:, constructor:, to_create:, traits:)
      @factory = factory
      @build_class = build_class
      @attributes = attributes
      @callbacks = callbacks.freeze
      @constructor = constructor
      @to_create = to_create
      @traits = traits.freeze
      @evaluator_class = EvaluatorClassDefiner.new(attributes, Evaluator).evaluator_class
    end

    def run(build_strategy, overrides, &block)
      block ||= ->(result) { result }

      strategy = Strategy.lookup_strategy(build_strategy).new

      evaluator = evaluator_class.new(strategy, overrides.symbolize_keys)
      attribute_assigner = AttributeAssigner.new(evaluator, build_class, &constructor)

      evaluation = Evaluation.new(evaluator, attribute_assigner, to_create, callbacks)

      evaluation.notify(:before_all, nil)
      instance = strategy.result(evaluation).tap(&block)
      evaluation.notify(:after_all, instance)

      instance
    end

    # Resolves a factory and its runtime traits without mutating any
    # Definition or Trait. Trait names resolve in the scope of the factory
    # being built: its own traits, then the parent chain's, then enum traits,
    # then the global registry.
    class Compilation
      Part = Struct.new(:attributes, :callbacks, :constructor, :to_create)

      def initialize(factory, trait_names)
        @factory = factory
        @trait_names = trait_names
        @build_class = factory.build_class
        @parent = factory.parent && Internal.compiled_factory(factory.parent, [])
        @scope = trait_scope
      end

      def result
        own = compile_definition(@factory.definition, @scope)
        runtime = @trait_names.map do |name|
          compile_trait(find_trait(name, @scope, @factory.definition), @scope)
        end

        CompiledFactory.new(
          factory: @factory,
          build_class: @build_class,
          attributes: merge_attributes(own, runtime),
          callbacks: (inherited_callbacks + own.callbacks + runtime.flat_map(&:callbacks)).uniq,
          constructor: runtime.map(&:constructor).compact.last || own.constructor || inherited_constructor,
          to_create: runtime.map(&:to_create).compact.last || own.to_create || inherited_to_create,
          traits: @scope
        )
      end

      private

      def merge_attributes(own, runtime)
        AttributeList.new(@factory.name).tap do |list|
          list.apply_attributes(@parent.attributes) if @parent
          list.apply_attributes(own.attributes)
          runtime.each { |part| list.apply_attributes(part.attributes) }
        end
      end

      def inherited_callbacks
        @parent ? @parent.callbacks : Internal.callbacks
      end

      def inherited_constructor
        @parent ? @parent.constructor : Internal.constructor
      end

      def inherited_to_create
        @parent ? @parent.to_create : Internal.to_create
      end

      def trait_scope
        inherited = @parent ? @parent.traits : {}
        enum_traits.merge(inherited).merge(traits_by_name(@factory.definition))
      end

      # The first trait declared with a name wins, as it always has.
      def traits_by_name(definition)
        definition.defined_traits.each_with_object({}) do |trait, traits|
          traits[trait.name] ||= trait
        end
      end

      def enum_traits
        enums.flat_map { |enum| enum.build_traits(@build_class) }.each_with_object({}) do |trait, traits|
          traits[trait.name] ||= trait
        end
      end

      def enums
        registered = @factory.definition.registered_enums

        if FactoryBot.automatically_define_enum_traits && @build_class.respond_to?(:defined_enums)
          registered + @build_class.defined_enums.keys.map { |name| Enum.new(name) }
        else
          registered
        end
      end

      def compile_trait(trait, scope)
        compile_definition(trait.definition, scope.merge(traits_by_name(trait.definition)))
      end

      def compile_definition(definition, scope)
        payload = {
          name: definition.name,
          traits: definition.defined_traits + @factory.definition.defined_traits,
          class: @build_class
        }

        ActiveSupport::Notifications.instrument("factory_bot.compile_factory", payload) do
          # Building the declarations registers implicit trait references, so
          # it has to happen before base_traits is read.
          attributes = definition.declarations.attributes
          payload[:attributes] = attributes

          base = definition.base_traits.map do |name|
            compile_trait(find_trait(name, scope, definition), scope)
          end

          Part.new(
            base.flat_map { |part| part.attributes } + attributes.to_a,
            base.flat_map(&:callbacks) + definition.callbacks,
            definition.constructor || base.map(&:constructor).compact.last,
            definition.to_create || base.map(&:to_create).compact.last
          )
        end
      end

      def find_trait(name, scope, definition)
        scope.fetch(name.to_s) { Internal.trait_by_name(name, @build_class) }
      rescue KeyError => error
        raise error_with_definition_name(error, scope, definition)
      end

      def error_with_definition_name(error, scope, definition)
        message = original_message(error).rstrip
        message += "." unless message.end_with?(".")
        message += " #{registered_trait_message(scope)}."
        message += " Referenced within \"#{definition.name}\" definition"

        new_error(error, message, scope).tap { |new_error| new_error.set_backtrace(error.backtrace) }
      end

      def registered_trait_message(scope)
        names = (scope.keys + Internal.traits.map(&:name)).uniq

        if names.empty?
          "No registered traits"
        else
          "Registered traits: #{names.map(&:to_sym).sort.inspect}"
        end
      end

      # Adds the traits in scope to the receiver so did_you_mean can suggest them.
      def error_options(error, scope)
        receiver = error.receiver

        if receiver.is_a?(Hash)
          receiver = receiver.dup
          scope.each_key do |trait_name|
            receiver[trait_name] = nil unless receiver.key?(trait_name)
          end
        end

        {key: error.key, receiver: receiver}
      end

      # Before Ruby 3.2, did_you_mean embeds its suggestions in the message itself.
      def original_message(error)
        error.message.partition("\nDid you mean?").first
      end

      # detailed_message introduced in Ruby 3.2 for cleaner integration with
      # did_you_mean. See https://bugs.ruby-lang.org/issues/18564
      if KeyError.method_defined?(:detailed_message)
        def new_error(error, message, scope)
          error.class.new(message, **error_options(error, scope))
        end
      else
        # Embed the suggestions so Exception#original_message includes them too.
        def new_error(error, message, scope)
          options = error_options(error, scope)
          error.class.new(error.class.new(message, **options).message, **options)
        end
      end
    end
  end
end
