module FactoryGirl
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
      else raise "unrecognized method #{@name_or_object}"
      end
    end
  end
end
