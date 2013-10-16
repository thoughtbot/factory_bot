require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/class/attribute'

module FactoryGirl
  # @api private
  class Evaluator
    class_attribute :attribute_lists

    private_instance_methods.each do |method|
      undef_method(method) unless method =~ /^__|initialize/
    end

    def initialize(build_strategy, overrides = {})
      @build_strategy = build_strategy
      @overrides = overrides
      @cached_attributes = overrides
      @instance = nil

      extend HashModuleGenerator.new(@overrides).to_module
    end

    def association(factory_name, *traits_and_overrides)
      overrides = traits_and_overrides.extract_options!
      strategy_override = overrides.fetch(:strategy) { :create }

      traits_and_overrides += [overrides.except(:strategy)]

      runner = FactoryRunner.new(factory_name, strategy_override, traits_and_overrides)
      @build_strategy.association(runner)
    end

    def instance=(object_instance)
      @instance = object_instance
    end

    def method_missing(method_name, *args, &block)
      if @instance.respond_to?(method_name)
        @instance.send(method_name, *args, &block)
      else
        SyntaxRunner.new.send(method_name, *args, &block)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @instance.respond_to?(method_name) || SyntaxRunner.new.respond_to?(method_name)
    end

    def __override_names__
      @overrides.keys
    end

    def increment_sequence(sequence)
      sequence.next(self)
    end

    def self.attribute_list
      AttributeList.new.tap do |list|
        attribute_lists.each do |attribute_list|
          list.apply_attributes attribute_list.to_a
        end
      end
    end
  end
end
