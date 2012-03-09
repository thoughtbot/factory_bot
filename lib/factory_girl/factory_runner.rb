module FactoryGirl
  class FactoryRunner
    def initialize(name, strategy, traits_and_overrides)
      @name     = name
      @strategy = strategy

      @overrides = traits_and_overrides.extract_options!
      @traits    = traits_and_overrides
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
