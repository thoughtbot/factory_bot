module FactoryGirl
  class FactoryRunner
    def initialize(name, strategy, traits_and_overrides)
      @name     = name
      @strategy = strategy

      @overrides = if traits_and_overrides.last.respond_to?(:has_key?)
                    traits_and_overrides.pop
                  else
                    {}
                  end
      @traits = traits_and_overrides
    end

    def run(strategy_override = nil, &block)
      strategy_override ||= @strategy
      factory = FactoryGirl.factory_by_name(@name)

      factory.compile

      if @traits.any?
        factory = factory.with_traits(@traits)
      end

      factory.run(strategy_override, @overrides, &block)
    end
  end
end
