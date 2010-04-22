PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

$: << File.join(PROJECT_ROOT, 'lib')

if ENV['CUSTOM_RAILS']
  gem 'activerecord', ENV['CUSTOM_RAILS']
end

require 'active_record'
require 'factory_girl'
