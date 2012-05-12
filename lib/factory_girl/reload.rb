module FactoryGirl
  def self.reload
    self.reset_configuration
    self.register_default_strategies
    self.register_default_callbacks
    self.find_definitions
  end
end
