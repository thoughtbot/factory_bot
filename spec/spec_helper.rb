require "rspec"
require "rspec/its"

require "simplecov"

require "factory_bot"

if RUBY_ENGINE == "jruby"
  # Workaround for issue in I18n/JRuby combo.
  # See https://github.com/jruby/jruby/issues/6547 and
  # https://github.com/ruby-i18n/i18n/issues/555
  require "i18n/backend"
  require "i18n/backend/simple"
end

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

  config.order = :random
  Kernel.srand config.seed

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
end
