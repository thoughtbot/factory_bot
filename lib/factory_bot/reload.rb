module FactoryBot
  def self.reload
    Internal.reset
    Internal.register_default_strategies
    find_definitions
  end
end
