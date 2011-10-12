$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require 'factory_girl'
require "mocha"
require "bourne"
require "timecop"

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_framework = :mocha
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include FactoryGirl::Syntax::Methods, :syntax_methods

  config.after do
    FactoryGirl.factories.clear
    FactoryGirl.sequences.clear
    FactoryGirl.traits.clear
  end
end
