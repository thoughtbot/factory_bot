module FactoryBot
  # Evaluates a compiled factory's attributes for one run. A BasicObject so
  # attribute names such as hash, display or method are not shadowed by Object.
  # @api private
  class Evaluator < ::BasicObject
    attr_accessor :instance

    def initialize(compiled, build_strategy, overrides = {})
      @compiled = compiled
      @build_strategy = build_strategy
      @overrides = overrides
      @memo = overrides.dup
      @instance = nil
      @hash_mode = false
      @constructing = false
      @evaluating = 0
      @read_in_constructor = []
    end

    def association(factory_name, *traits_and_overrides)
      overrides = traits_and_overrides.extract_options!
      strategy_override = overrides.fetch(:strategy) {
        ::FactoryBot.use_parent_strategy ? @build_strategy.to_sym : :create
      }

      traits_and_overrides += [overrides.except(:strategy)]

      runner = ::FactoryBot::FactoryRunner.new(factory_name, strategy_override, traits_and_overrides)
      @build_strategy.association(runner)
    end

    # Available inside initialize_with, where they shadow attributes of the same name.
    def new(...)
      __constructing__ ? @compiled.build_class.new(...) : method_missing(:new, ...)
    end

    def attributes
      __constructing__ ? __attributes__ : method_missing(:attributes)
    end

    def method_missing(name, ...)
      if __attribute?(name)
        __read__(name)
      elsif @instance.respond_to?(name)
        @instance.send(name, ...)
      elsif @hash_mode && @compiled.build_class.method_defined?(name)
        nil
      else
        ::FactoryBot::SyntaxRunner.new.send(name, ...)
      end
    end

    def respond_to?(name, include_private = false)
      respond_to_missing?(name, include_private)
    end

    def respond_to_missing?(name, _include_private = false)
      __attribute?(name) ||
        @instance.respond_to?(name) ||
        ::FactoryBot::SyntaxRunner.new.respond_to?(name)
    end

    def send(...)
      __send__(...)
    end

    def public_send(...)
      __send__(...)
    end

    def nil?
      false
    end

    def inspect
      "#<FactoryBot::Evaluator>"
    end

    def increment_sequence(sequence, scope: self)
      value = sequence.next(scope)

      ::Kernel.raise if value.respond_to?(:start_with?) && value.start_with?("#<FactoryBot::Declaration")

      value
    rescue
      ::Kernel.raise ::ArgumentError, "Sequence '#{sequence.uri_manager.first}' failed to " \
                                      "return a value. Perhaps it needs a scope to operate? (scope: <object>)"
    end

    def __override_names__
      @overrides.keys
    end

    # Without an instance, as under attributes_for, build class methods answer nil.
    def __hash_mode__!
      @hash_mode = true
    end

    def __construct__(attribute_names, &constructor)
      @assignable_attribute_names = attribute_names
      @constructing = true
      instance_exec(&constructor)
    ensure
      @constructing = false
    end

    # Attributes read directly by initialize_with, which need no assignment afterwards.
    def __read_in_constructor__
      @read_in_constructor.uniq
    end

    def __read__(name)
      @read_in_constructor << name if __constructing__

      if @memo.key?(name)
        @memo[name]
      else
        @memo[name] = __evaluate__(@compiled.attributes.fetch(name))
      end
    end

    def __attribute?(name)
      @memo.key?(name) || @compiled.attributes.key?(name)
    end

    def __constructing__
      @constructing && @evaluating.zero?
    end

    def __attributes__
      @assignable_attribute_names.each_with_object({}) do |name, result|
        result[name] = __read__(name)
      end
    end

    def __evaluate__(attribute)
      @evaluating += 1
      instance_exec(&attribute.to_proc)
    ensure
      @evaluating -= 1
    end
  end
end
