module FactoryBot
  module Internal
    module Strategies
      def self.strategies
        @strategies ||= Registry.new("Strategy")
      end

      def self.reset
        @strategies&.reset
      end

      def self.strategy_by_name(name)
        strategies.find(name)
      end

      def self.register_default_strategies
        register_strategy(:build, FactoryBot::Strategy::Build)
        register_strategy(:create, FactoryBot::Strategy::Create)
        register_strategy(:attributes_for, FactoryBot::Strategy::AttributesFor)
        register_strategy(:build_stubbed, FactoryBot::Strategy::Stub)
        register_strategy(:null, FactoryBot::Strategy::Null)
      end

      def self.register_strategy(strategy_name, strategy_class)
        strategies.register(strategy_name, strategy_class)
        StrategySyntaxMethodRegistrar.define_strategy_methods(strategy_name)
      end
    end
  end
end
