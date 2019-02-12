module FactoryBot
  def self.reload
    Internal.reset_configuration
    register_default_strategies
    register_default_callbacks
    find_definitions
  end
end
