$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'

if ENV['CUSTOM_RAILS']
  gem 'activerecord', ENV['CUSTOM_RAILS']
end

require 'active_record'

require 'spec'
require 'spec/autorun'
require 'rr'

require 'models'

require 'factory_girl'

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end
