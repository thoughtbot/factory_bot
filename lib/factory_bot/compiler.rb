module FactoryBot
  # Resolves a factory and a list of trait names into a CompiledFactory. It
  # reads definitions without changing them and resolves trait names in the
  # scope of the factory being built: its own traits, then the parent chain,
  # then enum traits, then global traits.
  # @api private
  class Compiler
    Resolved = Struct.new(:attributes, :callbacks, :constructor, :to_create)

    def initialize(factory, trait_names = [])
      @factory = factory
      @trait_names = trait_names
      @enum_traits = {}
    end

    def compile
      parent = @factory.parent.compiled
      own = resolve(definition)
      traits = lookup_traits(@trait_names, definition).map { |trait| resolve(trait.definition) }

      CompiledFactory.new(
        build_class: build_class,
        attributes: merge_attributes(parent.attributes, [own, *traits].flat_map(&:attributes)),
        callbacks: (parent.callbacks + own.callbacks + traits.flat_map(&:callbacks)).uniq,
        constructor: traits.filter_map(&:constructor).last || own.constructor || parent.constructor,
        to_create: traits.filter_map(&:to_create).last || own.to_create || parent.to_create
      )
    end

    # Every trait name the factory can use without reaching for a global trait.
    def trait_names
      traits_in_scope.map(&:name).uniq
    end

    private

    def definition
      @factory.definition
    end

    def build_class
      @factory.build_class
    end

    def resolve(definition)
      ActiveSupport::Notifications.instrument "factory_bot.compile_factory", {name: definition.name} do |payload|
        attributes, trait_names = resolve_declarations(definition)
        traits = lookup_traits(definition.base_traits + trait_names, definition)
        base = traits.map { |trait| resolve(trait.definition) }

        payload[:attributes] = attributes
        payload[:traits] = self.definition.defined_traits
        payload[:class] = build_class

        Resolved.new(
          base.flat_map(&:attributes) + attributes,
          base.flat_map(&:callbacks) + definition.callbacks,
          definition.constructor || base.filter_map(&:constructor).last,
          definition.to_create || base.filter_map(&:to_create).last
        )
      end
    end

    def resolve_declarations(definition)
      attributes = []
      trait_names = []

      definition.declarations.each do |declaration|
        attribute = build_attribute(declaration, definition)

        if attribute.nil?
          trait_names << declaration.name
        else
          ensure_not_self_referencing!(attribute, definition)
          ensure_not_defined!(attribute, attributes)
          attributes << attribute
        end
      end

      [attributes, trait_names]
    end

    # A bare word is an association, a global sequence, or a trait reference,
    # in which case this answers nil.
    def build_attribute(declaration, definition)
      case declaration
      when Declaration::Dynamic
        Attribute::Dynamic.new(declaration.name, declaration.transient, declaration.block)
      when Declaration::Association
        association_attribute(declaration)
      when Declaration::Implicit
        implicit_attribute(declaration, definition)
      end
    end

    def implicit_attribute(declaration, definition)
      name = declaration.name

      if Internal.factories.registered?(name)
        Attribute::Association.new(name, name, {})
      elsif Internal.sequences.registered?(name)
        Attribute::Sequence.new(name, name, declaration.transient)
      elsif definition.name.to_s == name.to_s
        raise TraitDefinitionError, "Self-referencing trait '#{name}'"
      end
    end

    def association_attribute(declaration)
      if declaration.factory_name.is_a?(Declaration)
        raise ArgumentError.new(<<~MSG)
          Association '#{declaration.name}' received an invalid factory argument.
          Did you mean? 'factory: :#{declaration.factory_name.name}'
        MSG
      end

      declaration.overrides.each do |attribute, value|
        if value.is_a?(Declaration)
          raise ArgumentError.new(<<~MSG)
            Association '#{declaration.name}' received an invalid attribute override.
            Did you mean? '#{attribute}: :#{value.name}'
          MSG
        end
      end

      Attribute::Association.new(
        declaration.name,
        declaration.factory_name,
        [declaration.traits, declaration.overrides].flatten
      )
    end

    def ensure_not_self_referencing!(attribute, definition)
      if attribute.association? && attribute.factory == definition.name
        message = "Self-referencing association '#{attribute.name}' in '#{attribute.factory}'"
        raise AssociationDefinitionError, message
      end
    end

    def ensure_not_defined!(attribute, attributes)
      if attributes.any? { |defined| defined.name == attribute.name }
        raise AttributeDefinitionError, "Attribute already defined: #{attribute.name}"
      end
    end

    # A later definition wins but keeps the first definition's position, and
    # a name declared transient anywhere stays transient.
    def merge_attributes(inherited, attributes)
      attributes.each_with_object(inherited.dup) do |attribute, merged|
        previous = merged[attribute.name]
        merged[attribute.name] = if previous&.transient && !attribute.transient
          attribute.as_transient
        else
          attribute
        end
      end
    end

    def lookup_traits(names, definition)
      names.uniq.map { |name| lookup_trait(name, definition) }
    end

    def lookup_trait(name, definition)
      trait_named(definition.defined_traits, name) ||
        trait_named(traits_in_scope, name) ||
        Internal.trait_by_name(name)
    rescue KeyError => error
      raise error_with_definition_name(error, definition)
    end

    def trait_named(traits, name)
      traits.find { |trait| trait.name == name.to_s }
    end

    def traits_in_scope
      @traits_in_scope ||= traits_in_scope_of(@factory)
    end

    def traits_in_scope_of(factory)
      return [] if factory.nil?

      factory.definition.defined_traits.to_a +
        traits_in_scope_of(factory.parent) +
        enum_traits(factory)
    end

    def enum_traits(factory)
      @enum_traits[factory] ||= begin
        klass = factory.build_class
        enums = factory.definition.registered_enums.dup

        if FactoryBot.automatically_define_enum_traits && klass.respond_to?(:defined_enums)
          enums += klass.defined_enums.keys.map { |name| Enum.new(name) }
        end

        enums.flat_map { |enum| enum.build_traits(klass) }
      end
    end

    def registered_trait_names(definition)
      (definition.defined_traits_names + trait_names + Internal.traits.map(&:name)).uniq
    end

    def error_options(error, definition)
      if error.respond_to?(:key) && error.respond_to?(:receiver)
        receiver = error.receiver
        if receiver.is_a?(Hash) || receiver.is_a?(ActiveSupport::HashWithIndifferentAccess)
          receiver = receiver.dup
          registered_trait_names(definition).each do |trait_name|
            receiver[trait_name] = nil unless receiver.key?(trait_name)
          end
        end
        {key: error.key, receiver: receiver}
      else
        {}
      end
    end

    # Before Ruby 3.2, did_you_mean embeds its suggestions in the message itself.
    def original_message(error)
      error.message.partition("\nDid you mean?").first
    end

    def registered_trait_message(definition)
      names = registered_trait_names(definition)

      if names.empty?
        "No registered traits"
      else
        "Registered traits: #{names.map(&:to_sym).sort.inspect}"
      end
    end

    def error_with_definition_name(error, definition)
      message = original_message(error).rstrip
      message += "." unless message.end_with?(".")
      message += " #{registered_trait_message(definition)}."
      message += " Referenced within \"#{definition.name}\" definition"

      new_error(error, message, definition).tap { |new_error| new_error.set_backtrace(error.backtrace) }
    end

    # detailed_message introduced in Ruby 3.2 for cleaner integration with
    # did_you_mean. See https://bugs.ruby-lang.org/issues/18564
    if KeyError.method_defined?(:detailed_message)
      def new_error(error, message, definition)
        error.class.new(message, **error_options(error, definition))
      end
    else
      # Embed the suggestions so Exception#original_message includes them too.
      def new_error(error, message, definition)
        options = error_options(error, definition)
        error.class.new(error.class.new(message, **options).message, **options)
      end
    end
  end
end
