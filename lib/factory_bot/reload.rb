module FactoryBot
  def self.reload
    Internal.reset_configuration
    Internal.register_default_strategies
    Internal.register_default_callbacks
    find_definitions
  end
end
