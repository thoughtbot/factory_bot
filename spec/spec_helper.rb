$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require "simplecov"

require 'factory_girl'
require "mocha/api"
require "bourne"
require "timecop"

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_framework = :mocha

  config.include DeclarationMatchers

  config.after do
    Timecop.return
    FactoryGirl.reload
  end
end
