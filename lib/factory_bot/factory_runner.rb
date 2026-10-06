module FactoryBot
  # One invocation of a factory: top-level `create(:user, :admin, name: "x")`
  # or an association from inside another run.
  class FactoryRunner
    def initialize(name, strategy_name, traits, overrides)
      @name = name
      @strategy_name = strategy_name
      @traits = traits
      @overrides = overrides.transform_keys(&:to_sym)
    end

    # A parent strategy may force the strategy, as build_stubbed does.
    def run(strategy_name = @strategy_name, &block)
      factory = FactoryBot.factories.find(@name)
      compiled = Compiler.compile(factory, @traits)
      payload = {name: @name, strategy: strategy_name, traits: @traits, overrides: @overrides, factory: factory}

      ActiveSupport::Notifications.instrument("factory_bot.before_run_factory", payload)
      ActiveSupport::Notifications.instrument("factory_bot.run_factory", payload) do
        strategy = Strategy.lookup(strategy_name).new
        evaluator = Evaluator.new(compiled, strategy, @overrides)
        evaluation = Evaluation.new(compiled, evaluator)

        evaluation.notify(:before_all, nil)
        instance = strategy.result(evaluation)
        block&.call(instance)
        evaluation.notify(:after_all, instance)
        instance
      end
    end
  end
end
