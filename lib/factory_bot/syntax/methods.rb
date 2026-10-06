module FactoryBot
  module Syntax
    # The strategy methods (build, create, build_stubbed, attributes_for and
    # their _list/_pair forms) plus generate. Include it in your test classes.
    module Methods
      def generate(name, scope: nil)
        FactoryBot.sequences.find(name).next(scope)
      end

      def generate_list(name, count, scope: nil)
        Array.new(count) { generate(name, scope: scope) }
      end

      # (name, *traits_and_overrides): overrides are a trailing Hash, whether
      # written as keywords or passed as a variable. Keys are symbolized.
      def self.split_overrides(args)
        traits, overrides = args.last.is_a?(Hash) ? [args[0...-1], args.last] : [args, {}]
        [traits, overrides.transform_keys(&:to_sym)]
      end

      def self.with_index(block, index)
        (block&.arity == 2) ? ->(instance) { block.call(instance, index) } : block
      end

      # Defines `name`, `name_list` and `name_pair` for a registered strategy.
      def self.define_strategy(strategy_name)
        list_name = :"#{strategy_name}_list"
        pair_name = :"#{strategy_name}_pair"

        [strategy_name, list_name, pair_name].each do |method_name|
          remove_method(method_name) if method_defined?(method_name, false)
        end

        define_method(strategy_name) do |name, *traits_and_overrides, &block|
          traits, overrides = Methods.split_overrides(traits_and_overrides)
          FactoryRunner.new(name, strategy_name, traits, overrides).run(&block)
        end

        define_method(list_name) do |name, count = nil, *traits_and_overrides, &block|
          raise ArgumentError, "count missing for #{list_name}" unless count.respond_to?(:times)

          Array.new(count) do |index|
            public_send(strategy_name, name, *traits_and_overrides, &Methods.with_index(block, index))
          end
        end

        define_method(pair_name) do |name, *traits_and_overrides, &block|
          Array.new(2) { public_send(strategy_name, name, *traits_and_overrides, &block) }
        end
      end
    end
  end
end
