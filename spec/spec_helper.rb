$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'rspec/its'

require "simplecov"

require 'factory_girl'
require "mocha/api"
require "bourne"
require "timecop"

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_framework = :mocha

  config.include DeclarationMatchers

  config.before do
    FactoryGirl.reload
  end

  config.after do
    Timecop.return
  end
end
