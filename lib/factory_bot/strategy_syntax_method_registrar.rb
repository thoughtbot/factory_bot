module FactoryBot
  # @api private
  module StrategySyntaxMethodRegistrar
    def self.define_strategy_methods(strategy_name)
      define_singular_strategy_method(strategy_name)
      define_list_strategy_method(strategy_name)
      define_pair_strategy_method(strategy_name)
    end

    def self.define_singular_strategy_method(strategy_name)
      define_syntax_method(strategy_name) do |name, *traits_and_overrides, &block|
        FactoryRunner.new(name, strategy_name, traits_and_overrides).run(&block)
      end
    end
    private_class_method :define_singular_strategy_method

    def self.define_list_strategy_method(strategy_name)
      define_syntax_method("#{strategy_name}_list") do |name, amount, *traits_and_overrides, &block|
        unless amount.respond_to?(:times)
          raise ArgumentError, "count missing for #{strategy_name}_list"
        end

        Array.new(amount) do |i|
          block_with_index = StrategySyntaxMethodRegistrar.with_index(block, i)
          send(strategy_name, name, *traits_and_overrides, &block_with_index)
        end
      end
    end
    private_class_method :define_list_strategy_method

    def self.define_pair_strategy_method(strategy_name)
      define_syntax_method("#{strategy_name}_pair") do |name, *traits_and_overrides, &block|
        Array.new(2) { send(strategy_name, name, *traits_and_overrides, &block) }
      end
    end
    private_class_method :define_pair_strategy_method

    def self.define_syntax_method(name, &block)
      FactoryBot::Syntax::Methods.module_exec do
        if method_defined?(name) || private_method_defined?(name)
          undef_method(name)
        end

        define_method(name, &block)
      end
    end
    private_class_method :define_syntax_method

    def self.with_index(block, index)
      if block&.arity == 2
        ->(instance) { block.call(instance, index) }
      else
        block
      end
    end
  end
end
