require "rspec"
require "rspec/its"

require "simplecov"

require "factory_girl"
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
    FactoryGirl.reload
  end

  config.after do
    Timecop.return
  end

  config.around do |example|
    begin
      previous_use_parent_strategy = FactoryGirl.use_parent_strategy
      example.run
    ensure
      FactoryGirl.use_parent_strategy = previous_use_parent_strategy
    end
  end

  config.order = :random
  Kernel.srand config.seed

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
end
