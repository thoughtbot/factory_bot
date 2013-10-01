require 'set'

require 'active_support'
require 'active_support/dependencies'
require 'active_support/core_ext/module/delegation'
require 'active_support/deprecation'
require 'active_support/notifications'

require 'factory_girl/errors'
require 'factory_girl/aliases'

require 'factory_girl/find_definitions'
require 'factory_girl/reload'

module FactoryGirl

  extend ActiveSupport::Autoload

  autoload :DefinitionHierarchy
  autoload :Configuration
  autoload :FactoryRunner
  autoload :StrategySyntaxMethodRegistrar
  autoload :StrategyCalculator
  autoload :Registry
  autoload :NullFactory
  autoload :NullObject
  autoload :Evaluation
  autoload :Factory
  autoload :AttributeAssigner
  autoload :Evaluator
  autoload :EvaluatorClassDefiner
  autoload :Attribute
  autoload :Callback
  autoload :CallbacksObserver
  autoload :DeclarationList
  autoload :Declaration
  autoload :Sequence
  autoload :AttributeList
  autoload :Trait
  autoload :Definition
  autoload :DefinitionProxy
  autoload :Syntax
  autoload :SyntaxRunner

  autoload :Strategy
  Strategy.autoload :Build, 'factory_girl/strategy/build'
  Strategy.autoload :Create, 'factory_girl/strategy/create'
  Strategy.autoload :AttributesFor, 'factory_girl/strategy/attributes_for'
  Strategy.autoload :Stub, 'factory_girl/strategy/stub'
  Strategy.autoload :Null, 'factory_girl/strategy/null'

  autoload :Decorator
  Decorator.autoload :AttributeHash, 'factory_girl/decorator/attribute_hash'
  Decorator.autoload :ClassKeyHash, 'factory_girl/decorator/class_key_hash'
  Decorator.autoload :DisallowsDuplicatesRegistry, 'factory_girl/decorator/disallows_duplicates_registry'
  Decorator.autoload :InvocationTracker, 'factory_girl/decorator/invocation_tracker'
  Decorator.autoload :NewConstructor, 'factory_girl/decorator/new_constructor'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = nil
  end

  class << self
    delegate :factories, :sequences, :traits, :callbacks, :strategies, :callback_names,
      :to_create, :skip_create, :initialize_with, :constructor, :duplicate_attribute_assignment_from_initialize_with,
      :duplicate_attribute_assignment_from_initialize_with=, to: :configuration
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

  def self.register_sequence(sequence)
    sequence.names.each do |name|
      sequences.register(name, sequence)
    end
    sequence
  end

  def self.sequence_by_name(name)
    sequences.find(name)
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

  def self.register_strategy(strategy_name, strategy_class)
    strategies.register(strategy_name, strategy_class)
    StrategySyntaxMethodRegistrar.new(strategy_name).define_strategy_methods
  end

  def self.strategy_by_name(name)
    strategies.find(name)
  end

  def self.register_default_strategies
    register_strategy(:build,          FactoryGirl::Strategy::Build)
    register_strategy(:create,         FactoryGirl::Strategy::Create)
    register_strategy(:attributes_for, FactoryGirl::Strategy::AttributesFor)
    register_strategy(:build_stubbed,  FactoryGirl::Strategy::Stub)
    register_strategy(:null,           FactoryGirl::Strategy::Null)
  end

  def self.register_default_callbacks
    register_callback(:after_build)
    register_callback(:after_create)
    register_callback(:after_stub)
    register_callback(:before_create)
  end

  def self.register_callback(name)
    name = name.to_sym
    callback_names << name
  end
end

FactoryGirl.register_default_strategies
FactoryGirl.register_default_callbacks
