$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require 'factory_woman'
require "mocha"
require "bourne"
require "timecop"

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_framework = :mocha

  config.include DeclarationMatchers

  config.after do
    FactoryWoman.factories.clear
    FactoryWoman.sequences.clear
    FactoryWoman.traits.clear
  end
end
