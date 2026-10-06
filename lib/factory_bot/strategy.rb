module FactoryBot
  # A strategy answers `association(runner)`, `result(evaluation)` and `to_sym`.
  # Custom strategies are registered with FactoryBot.register_strategy.
  module Strategy
    def self.lookup(name_or_class)
      name_or_class.is_a?(Class) ? name_or_class : FactoryBot.strategies.find(name_or_class)
    end
  end
end
