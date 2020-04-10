require "active_support"

RSpec.configure do |config|
  config.around :example, silence_deprecation: true do |example|
    with_temporary_assignment(FactoryBot::Deprecation, :silenced, true) do
      example.run
    end
  end
end
