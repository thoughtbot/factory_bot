module FactoryGirl
  def self.reload
    self.factories.clear
    self.sequences.clear
    self.traits.clear
    self.strategies.clear
    self.register_default_strategies
    self.find_definitions
  end
end
