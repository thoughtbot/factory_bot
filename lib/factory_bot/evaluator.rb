require "active_support/core_ext/class/attribute"

module FactoryBot
  # @api private
  class Evaluator
    class_attribute :attribute_lists
    class_attribute :attribute_blocks, default: {}, instance_accessor: false, instance_predicate: false

    private_instance_methods.each do |method|
      undef_method(method) unless method.match?(/^__|initialize/)
    end

    # Shadows attributes named new or attributes only while initialize_with runs.
    module Construction
      def new(...)
        __constructing__ ? @build_class.new(...) : super
      end

      def attributes
        __constructing__ ? __attributes__ : super
      end
    end

    def initialize(build_strategy, overrides = {})
      @build_strategy = build_strategy
      @overrides = overrides
      @cached_attributes = overrides
      @instance = nil
      @constructing = false
      @evaluating = 0
      @read_in_constructor = []

      @overrides.each do |name, value|
        singleton_class.define_attribute(name) { value }
      end
    end

    def association(factory_name, *traits_and_overrides)
      overrides = traits_and_overrides.extract_options!
      strategy_override = overrides.fetch(:strategy) {
        FactoryBot.use_parent_strategy ? @build_strategy.to_sym : :create
      }

      traits_and_overrides += [overrides.except(:strategy)]

      runner = FactoryRunner.new(factory_name, strategy_override, traits_and_overrides)
      @build_strategy.association(runner)
    end

    attr_accessor :instance

    def method_missing(method_name, ...)
      if @instance.respond_to?(method_name)
        @instance.send(method_name, ...)
      else
        SyntaxRunner.new.send(method_name, ...)
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      @instance.respond_to?(method_name) || SyntaxRunner.new.respond_to?(method_name)
    end

    def __override_names__
      @overrides.keys
    end

    def __construct__(build_class, attribute_names, &constructor)
      @build_class = build_class
      @assignable_attribute_names = attribute_names
      singleton_class.prepend(Construction)
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

      if @cached_attributes.key?(name)
        @cached_attributes[name]
      else
        @cached_attributes[name] = __evaluate__(&self.class.attribute_blocks.fetch(name))
      end
    end

    def __constructing__
      @constructing && @evaluating.zero?
    end

    def __attributes__
      @assignable_attribute_names.each_with_object({}) do |name, result|
        result[name] = __read__(name)
      end
    end

    def __evaluate__(&block)
      @evaluating += 1
      instance_exec(&block)
    ensure
      @evaluating -= 1
    end

    def increment_sequence(sequence, scope: self)
      value = sequence.next(scope)

      raise if value.respond_to?(:start_with?) && value.start_with?("#<FactoryBot::Declaration")

      value
    rescue
      raise ArgumentError, "Sequence '#{sequence.uri_manager.first}' failed to " \
                          "return a value. Perhaps it needs a scope to operate? (scope: <object>)"
    end

    def self.attribute_list
      AttributeList.new.tap do |list|
        attribute_lists.each do |attribute_list|
          list.apply_attributes attribute_list.to_a
        end
      end
    end

    def self.define_attribute(name, &block)
      if instance_methods(false).include?(name) || private_instance_methods(false).include?(name)
        undef_method(name)
      end

      self.attribute_blocks = attribute_blocks.merge(name => block)

      define_method(name) do
        __read__(name)
      end
    end
  end
end
