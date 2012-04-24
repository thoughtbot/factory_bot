PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

require "simplecov"

$: << File.join(PROJECT_ROOT, 'lib')

require 'active_record'
require 'factory_girl'

require 'aruba/cucumber'
