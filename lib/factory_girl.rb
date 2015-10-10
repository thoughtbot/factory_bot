require 'set'
require 'active_support/core_ext/module/delegation'
require 'active_support/deprecation'
require 'active_support/notifications'

require 'factory_girl/definition_hierarchy'
require 'factory_girl/configuration'
require 'factory_girl/errors'
require 'factory_girl/factory_runner'
require 'factory_girl/strategy_syntax_method_registrar'
require 'factory_girl/strategy_calculator'
require 'factory_girl/strategy/build'
require 'factory_girl/strategy/create'
require 'factory_girl/strategy/attributes_for'
require 'factory_girl/strategy/stub'
require 'factory_girl/strategy/null'
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
require 'factory_girl/decorator'
require 'factory_girl/decorator/attribute_hash'
require 'factory_girl/decorator/class_key_hash'
require 'factory_girl/decorator/disallows_duplicates_registry'
require 'factory_girl/decorator/invocation_tracker'
require 'factory_girl/decorator/new_constructor'
require 'factory_girl/linter'
require 'factory_girl/version'

module FactoryGirl
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = nil
  end

  # Look for errors in factories and (optionally) their traits.
  # Parameters:
  # factories - which factories to lint; omit for all factories
  # options:
  #   traits : true - to lint traits as well as factories
  def self.lint(*args)
    options = args.extract_options!
    factories_to_lint = args[0] || FactoryGirl.factories
    strategy = options[:traits] ? :factory_and_traits : :factory
    Linter.new(factories_to_lint, strategy).lint!
  end

  class << self
    delegate :factories,
             :sequences,
             :traits,
             :callbacks,
             :strategies,
             :callback_names,
             :to_create,
             :skip_create,
             :initialize_with,
             :constructor,
             :duplicate_attribute_assignment_from_initialize_with,
             :duplicate_attribute_assignment_from_initialize_with=,
             :allow_class_lookup,
             :allow_class_lookup=,
             :use_parent_strategy,
             :use_parent_strategy=,
             to: :configuration
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
