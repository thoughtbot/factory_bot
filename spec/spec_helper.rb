require "rspec"
require "rspec/its"

require "simplecov"

require "factory_bot"
require "timecop"

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a
    # real object. This is generally recommended, and will default to `true` in
    # RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.include DeclarationMatchers

  config.before do
    FactoryBot.reload
  end

  config.after do
    Timecop.return
  end

  config.order = :random
  Kernel.srand config.seed
end
