require "active_support/core_ext/hash/except"
require "active_support/core_ext/class/attribute"

module FactoryGirl
  class Evaluator
    class_attribute :attribute_lists

    def self.attribute_list
      AttributeList.new.tap do |list|
        attribute_lists.each do |attribute_list|
          list.apply_attributes attribute_list.to_a
        end
      end
    end

    private_instance_methods.each do |method|
      undef_method(method) unless method =~ /^__|initialize/
    end

    def initialize(build_class, build_strategy, overrides = {})
      @build_class       = build_class
      @build_strategy    = build_strategy
      @overrides         = overrides
      @cached_attributes = overrides

      @overrides.each do |name, value|
        singleton_class.send :define_method, name, -> { value }
      end
    end

    delegate :new, to: :@build_class

    def association(factory_name, overrides = {})
      strategy_override = overrides.fetch(:strategy) { FactoryGirl.strategy_by_name(:create) }

      build_strategy = StrategyCalculator.new(strategy_override).strategy
      runner = FactoryRunner.new(factory_name, build_strategy, [overrides.except(:strategy)])
      @build_strategy.association(runner)
    end

    def instance=(object_instance)
      @instance = object_instance
    end

    def method_missing(method_name, *args, &block)
      if @cached_attributes.key?(method_name)
        @cached_attributes[method_name]
      else
        if @instance.respond_to?(method_name)
          @instance.send(method_name, *args, &block)
        else
          SyntaxRunner.new.send(method_name, *args, &block)
        end
      end
    end

    def __override_names__
      @overrides.keys
    end
  end
end
