module FactoryBot
  # The receiver of attribute blocks, initialize_with, inline sequences, and the
  # second argument of callbacks and to_create. One instance per run.
  #
  # A bare name resolves, in order, to: an override or an already computed
  # value, a compiled attribute (evaluated once), a method on the instance
  # being built, nil under attributes_for when the build class defines the
  # method, and finally a SyntaxRunner (build, create, generate, Kernel).
  class Evaluator < BasicObject
    attr_accessor :instance

    def initialize(compiled, build_strategy, overrides)
      @compiled = compiled
      @build_strategy = build_strategy
      @overrides = overrides
      @memo = overrides.dup
      @instance = nil
      @hash_mode = false
      @constructing = false
      @evaluating = []
      @read_in_constructor = []
    end

    def association(factory_name, *traits_and_overrides)
      traits, overrides = ::FactoryBot::Syntax::Methods.split_overrides(traits_and_overrides)
      strategy_name = overrides.fetch(:strategy) { @build_strategy.to_sym }
      runner = ::FactoryBot::FactoryRunner.new(factory_name, strategy_name, traits, overrides.except(:strategy))
      @build_strategy.association(runner)
    end

    # Every assignable attribute, for `initialize_with { new(**attributes) }`.
    def attributes
      names = ::FactoryBot::Evaluation.assignable_names(@compiled.attributes, @overrides.keys)
      names.to_h { |name| [name, __read__(name)] }
    end

    def new(...)
      @compiled.build_class.new(...)
    end

    def method_missing(name, ...)
      if @memo.key?(name) || @compiled.attributes.key?(name)
        __read__(name)
      elsif @instance&.respond_to?(name)
        @instance.public_send(name, ...)
      elsif @hash_mode && @compiled.build_class.method_defined?(name)
        nil
      else
        ::FactoryBot::SyntaxRunner.new.__send__(name, ...)
      end
    end

    def respond_to?(name, include_private = false)
      @memo.key?(name) || @compiled.attributes.key?(name) ||
        @instance&.respond_to?(name, include_private) ||
        ::FactoryBot::SyntaxRunner.new.respond_to?(name, include_private)
    end

    def respond_to_missing?(name, include_private = false)
      respond_to?(name, include_private)
    end

    def inspect
      "#<FactoryBot::Evaluator #{@compiled.factory.name}>"
    end

    alias_method :to_s, :inspect

    # The methods below are the protocol used by Evaluation. Their names cannot
    # collide with attribute names.

    def __read__(name)
      @read_in_constructor << name if @constructing && @evaluating.empty?
      return @memo[name] if @memo.key?(name)

      @memo[name] = __evaluate__(@compiled.attributes.fetch(name))
    end

    def __construct__(constructor)
      @constructing = true
      self.instance = instance_exec(&constructor)
    ensure
      @constructing = false
    end

    def __hash_mode__!
      @hash_mode = true
    end

    def __override_names__
      @overrides.keys
    end

    def __read_in_constructor__
      @read_in_constructor
    end

    private

    def __evaluate__(attribute)
      if @evaluating.include?(attribute.name)
        ::Kernel.raise ::FactoryBot::AttributeDefinitionError,
          "Circular attribute reference: #{[*@evaluating, attribute.name].join(" -> ")}"
      end

      @evaluating.push(attribute.name)

      if attribute.association?
        association(attribute.factory, *attribute.traits, attribute.overrides)
      elsif [1, -1, -2].include?(attribute.block.arity)
        instance_exec(self, &attribute.block)
      else
        instance_exec(&attribute.block)
      end
    ensure
      @evaluating.pop
    end
  end
end
