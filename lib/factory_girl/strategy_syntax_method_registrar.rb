module FactoryGirl
  # @api private
  class StrategySyntaxMethodRegistrar
    def initialize(strategy_name)
      @strategy_name = strategy_name
    end

    def define_strategy_methods
      define_singular_strategy_method
      define_list_strategy_method
      define_detailed_list_strategy_method
      define_pair_strategy_method
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

    def define_detailed_list_strategy_method
      strategy_name = @strategy_name
      define_syntax_method("#{strategy_name}_detailed_list") do |name, amount, details, &block|
        amount.times.map.with_index { |i|
          overrides = {}
          details.map{ |key, value| overrides[key] = value[i] unless value[i].nil?  } 
          send(strategy_name, name, overrides, &block)
        }
      end   
    end

    def define_pair_strategy_method
      strategy_name = @strategy_name

      define_syntax_method("#{strategy_name}_pair") do |name, *traits_and_overrides, &block|
        2.times.map { send(strategy_name, name, *traits_and_overrides, &block) }
      end
    end

    def define_syntax_method(name, &block)
      FactoryGirl::Syntax::Methods.module_exec do
        define_method(name, &block)
      end
    end
  end
end
