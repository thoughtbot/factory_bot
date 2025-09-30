module FactoryBot
  # @api private
  module Internal
    class << self
      delegate :after,
        :before,
        :callbacks,
        :constructor,
        :initialize_with,
        :skip_create,
        :strategies,
        :to_create,
        to: :configuration

      delegate :traits,
        :register_trait,
        :trait_by_name,
        to: Internal::Traits

      delegate :factories,
        :register_factory,
        :factory_by_name,
        to: Internal::Factories

      delegate :sequences,
        :inline_sequences,
        :register_inline_sequence,
        :rewind_inline_sequences,
        :register_sequence,
        :sequence_by_name,
        :rewind_sequence,
        :rewind_sequences,
        :set_sequence,
        to: Internal::Sequences

      def configuration
        @configuration ||= Configuration.new
      end

      def reset_configuration
        @configuration = nil
        Internal::Traits.reset_traits
        Internal::Factories.reset_factories
        Internal::Sequences.reset
      end

      def register_strategy(strategy_name, strategy_class)
        strategies.register(strategy_name, strategy_class)
        StrategySyntaxMethodRegistrar.new(strategy_name).define_strategy_methods
      end

      def strategy_by_name(name)
        strategies.find(name)
      end

      def register_default_strategies
        register_strategy(:build, FactoryBot::Strategy::Build)
        register_strategy(:create, FactoryBot::Strategy::Create)
        register_strategy(:attributes_for, FactoryBot::Strategy::AttributesFor)
        register_strategy(:build_stubbed, FactoryBot::Strategy::Stub)
        register_strategy(:null, FactoryBot::Strategy::Null)
      end
    end
  end
end
