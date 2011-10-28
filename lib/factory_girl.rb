require "active_support/core_ext/module/delegation"

require 'factory_girl/proxy'
require 'factory_girl/proxy/build'
require 'factory_girl/proxy/create'
require 'factory_girl/proxy/attributes_for'
require 'factory_girl/proxy/stub'
require 'factory_girl/registry'
require 'factory_girl/factory'
require 'factory_girl/attribute'
require 'factory_girl/attribute/static'
require 'factory_girl/attribute/dynamic'
require 'factory_girl/attribute/association'
require 'factory_girl/attribute/sequence'
require 'factory_girl/callback'
require 'factory_girl/declaration_list'
require 'factory_girl/declaration'
require 'factory_girl/declaration/static'
require 'factory_girl/declaration/dynamic'
require 'factory_girl/declaration/association'
require 'factory_girl/declaration/implicit'
require 'factory_girl/sequence'
require 'factory_girl/attribute_list'
require 'factory_girl/trait'
require 'factory_girl/aliases'
require 'factory_girl/definition_proxy'
require 'factory_girl/syntax/methods'
require 'factory_girl/syntax/default'
require 'factory_girl/syntax/vintage'
require 'factory_girl/find_definitions'
require 'factory_girl/reload'
require 'factory_girl/deprecated'
require 'factory_girl/version'

if defined?(Rails) && Rails::VERSION::MAJOR == 2
  require 'factory_girl/rails2'
end

module FactoryGirl
  # Raised when a factory is defined that attempts to instantiate itself.
  class AssociationDefinitionError < RuntimeError; end

  # Raised when a callback is defined that has an invalid name
  class InvalidCallbackNameError < RuntimeError; end

  # Raised when a factory is defined with the same name as a previously-defined factory.
  class DuplicateDefinitionError < RuntimeError; end

  def self.factories
    @factories ||= Registry.new("Factory")
  end

  def self.register_factory(factory)
    factories.add(factory)
  end

  def self.factory_by_name(name)
    factories.find(name)
  end

  def self.sequences
    @sequences ||= Registry.new("Sequence")
  end

  def self.register_sequence(sequence)
    sequences.add(sequence)
  end

  def self.sequence_by_name(name)
    sequences.find(name)
  end

  def self.traits
    @traits ||= Registry.new("Trait")
  end

  def self.register_trait(trait)
    traits.add(trait)
  end

  def self.trait_by_name(name)
    traits.find(name)
  end
end
