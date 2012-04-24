require "active_support/core_ext/module/delegation"
require "active_support/notifications"

require 'factory_girl/errors'
require 'factory_girl/factory_runner'
require 'factory_girl/strategy_calculator'
require "factory_girl/strategy/build"
require "factory_girl/strategy/create"
require "factory_girl/strategy/attributes_for"
require "factory_girl/strategy/stub"
require "factory_girl/strategy/null"
require 'factory_girl/disallows_duplicates_registry'
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
    @factories ||= DisallowsDuplicatesRegistry.new(Registry.new("Factory"))
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
    @sequences ||= DisallowsDuplicatesRegistry.new(Registry.new("Sequence"))
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
    @traits ||= DisallowsDuplicatesRegistry.new(Registry.new("Trait"))
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

  def self.strategies
    @strategies ||= Registry.new("Strategy")
  end

  def self.register_strategy(strategy_name, strategy_class)
    strategies.register(strategy_name, strategy_class)

    FactoryGirl::Syntax::Methods.module_exec do
      define_method(strategy_name) do |name, *traits_and_overrides, &block|
        instrumentation_payload = { name: name, strategy: strategy_name }

        ActiveSupport::Notifications.instrument("factory_girl.run_factory", instrumentation_payload) do
          FactoryRunner.new(name, strategy_class, traits_and_overrides).run(&block)
        end
      end
    end
  end

  def self.strategy_by_name(name)
    strategies.find(name)
  end

  def self.register_default_strategies
    FactoryGirl.register_strategy(:build,          FactoryGirl::Strategy::Build)
    FactoryGirl.register_strategy(:create,         FactoryGirl::Strategy::Create)
    FactoryGirl.register_strategy(:attributes_for, FactoryGirl::Strategy::AttributesFor)
    FactoryGirl.register_strategy(:build_stubbed,  FactoryGirl::Strategy::Stub)
  end

  def self.callback_names
    [:after_build, :after_create, :after_stub, :before_create].freeze
  end
end

FactoryGirl.register_default_strategies
