require "factory_bot/internal/definition"
require "factory_bot/internal/factories"
require "factory_bot/internal/sequences"
require "factory_bot/internal/strategies"
require "factory_bot/internal/traits"

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
        to: Internal::Definition

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

      delegate :strategies,
        :register_strategy,
        :strategy_by_name,
        :register_default_strategies,
        to: Internal::Strategies
    end

    def self.reset
      Internal::Traits.reset
      Internal::Factories.reset
      Internal::Sequences.reset
      Internal::Strategies.reset
      Internal::Definition.reset
    end
  end
end
