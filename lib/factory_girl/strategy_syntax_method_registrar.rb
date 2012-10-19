module FactoryGirl
  # @api private
  class StrategySyntaxMethodRegistrar
    def initialize(strategy_name)
      @strategy_name = strategy_name
    end

    def define_strategy_methods
      define_singular_strategy_method
      define_list_strategy_method
    end

    private

    def define_singular_strategy_method
      strategy_name = @strategy_name

      define_syntax_method(strategy_name) do |name, *traits_and_overrides, &block|
        FactoryRunner.new(name, strategy_name, traits_and_overrides).run(&block)
      end
    end

    def define_list_strategy_method
      strategy_name = @strategy_name

      define_syntax_method("#{strategy_name}_list") do |name, amount, *traits_and_overrides, &block|
        amount.times.map { send(strategy_name, name, *traits_and_overrides, &block) }
      end
    end

    def define_syntax_method(name, &block)
      FactoryGirl::Syntax::Methods.module_exec do
        define_method(name, &block)
      end
    end
  end
end
