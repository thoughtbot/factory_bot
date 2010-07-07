require 'factory_girl/proxy'
require 'factory_girl/proxy/build'
require 'factory_girl/proxy/create'
require 'factory_girl/proxy/attributes_for'
require 'factory_girl/proxy/stub'
require 'factory_girl/factory'
require 'factory_girl/attribute'
require 'factory_girl/attribute/static'
require 'factory_girl/attribute/dynamic'
require 'factory_girl/attribute/association'
require 'factory_girl/attribute/callback'
require 'factory_girl/sequence'
require 'factory_girl/aliases'
require 'factory_girl/definition_proxy'
require 'factory_girl/syntax/default'
require 'factory_girl/syntax/vintage'
require 'factory_girl/find_definitions'
require 'factory_girl/deprecated'

module FactoryGirl
  VERSION = "1.3.1"
end

if defined?(Rails) && Rails::VERSION::MAJOR == 2
  require 'factory_girl/rails2'
end

