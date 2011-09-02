module FactoryGirl
  def self.reload
    self.factories.clear
    self.sequences.clear
    self.traits.clear
    self.find_definitions
  end
end
