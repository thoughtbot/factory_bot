module FactoryGirl
  class AssociationRunner
    def initialize(factory_name, strategy_name_or_object, overrides)
      @factory_name            = factory_name
      @strategy_name_or_object = strategy_name_or_object
      @overrides               = overrides
    end

    def run(strategy_override = nil)
      strategy_name_or_object = strategy_override || @strategy_name_or_object
      strategy = StrategyCalculator.new(strategy_name_or_object).strategy
      factory.run(strategy, @overrides)
    end

    private

    def factory
      FactoryGirl.factory_by_name(@factory_name)
    end

    class StrategyCalculator
      def initialize(name_or_object)
        @name_or_object = name_or_object
      end

      def strategy
        if strategy_is_object?
          @name_or_object
        else
          strategy_name_to_object
        end
      end

      private

      def strategy_is_object?
        @name_or_object.is_a?(Class) && @name_or_object.ancestors.include?(::FactoryGirl::Strategy)
      end

      def strategy_name_to_object
        case @name_or_object
        when :build  then Strategy::Build
        when :create then Strategy::Create
        when nil     then Strategy::Create
        else raise "unrecognized method #{@name_or_object}"
        end
      end
    end
  end
end
