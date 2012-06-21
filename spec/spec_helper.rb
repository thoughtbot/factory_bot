$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require "simplecov"

require 'factory_girl'
require "mocha"
require "bourne"
require "timecop"

require 'factory_girl/helper/testing'

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_framework = :mocha

  config.include DeclarationMatchers
  config.include FactoryGirl::TestingHelper

  config.after do
    FactoryGirl.reload
  end
end
