require "active_support/core_ext/module/delegation"

require 'factory_girl/errors'
require 'factory_girl/factory_runner'
require 'factory_girl/strategy_calculator'
require "factory_girl/strategy/build"
require "factory_girl/strategy/create"
require "factory_girl/strategy/attributes_for"
require "factory_girl/strategy/stub"
require "factory_girl/strategy/null"
require 'factory_girl/registry'
require 'factory_girl/null_factory'
require 'factory_girl/null_object'
require 'factory_girl/evaluation'
require 'factory_girl/factory'
require 'factory_girl/attribute_assigner'
require 'factory_girl/evaluator'
require 'factory_girl/evaluator_class_definer'
require 'factory_girl/attribute'
require 'factory_girl/callback'
require 'factory_girl/callbacks_observer'
require 'factory_girl/declaration_list'
require 'factory_girl/declaration'
require 'factory_girl/sequence'
require 'factory_girl/attribute_list'
require 'factory_girl/trait'
require 'factory_girl/aliases'
require 'factory_girl/definition'
require 'factory_girl/definition_proxy'
require 'factory_girl/syntax'
require 'factory_girl/syntax_runner'
require 'factory_girl/find_definitions'
require 'factory_girl/reload'
require 'factory_girl/version'

module FactoryGirl
  def self.factories
    @factories ||= Registry.new("Factory")
  end

  def self.register_factory(factory)
    factory.names.each do |name|
      factories.register(name, factory)
    end
    factory
  end

  def self.factory_by_name(name)
    factories.find(name)
  end

  def self.sequences
    @sequences ||= Registry.new("Sequence")
  end

  def self.register_sequence(sequence)
    sequence.names.each do |name|
      sequences.register(name, sequence)
    end
    sequence
  end

  def self.sequence_by_name(name)
    sequences.find(name)
  end

  def self.traits
    @traits ||= Registry.new("Trait")
  end

  def self.register_trait(trait)
    trait.names.each do |name|
      traits.register(name, trait)
    end
    trait
  end

  def self.trait_by_name(name)
    traits.find(name)
  end

  def self.callback_names
    [:after_build, :after_create, :after_stub, :before_create].freeze
  end
end
