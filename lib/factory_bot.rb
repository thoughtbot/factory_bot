require "set"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/deprecation"
require "active_support/notifications"

require "factory_bot/definition_hierarchy"
require "factory_bot/configuration"
require "factory_bot/errors"
require "factory_bot/factory_runner"
require "factory_bot/strategy_syntax_method_registrar"
require "factory_bot/strategy_calculator"
require "factory_bot/strategy/build"
require "factory_bot/strategy/create"
require "factory_bot/strategy/attributes_for"
require "factory_bot/strategy/stub"
require "factory_bot/strategy/null"
require "factory_bot/registry"
require "factory_bot/null_factory"
require "factory_bot/null_object"
require "factory_bot/evaluation"
require "factory_bot/factory"
require "factory_bot/attribute_assigner"
require "factory_bot/evaluator"
require "factory_bot/evaluator_class_definer"
require "factory_bot/attribute"
require "factory_bot/callback"
require "factory_bot/callbacks_observer"
require "factory_bot/declaration_list"
require "factory_bot/declaration"
require "factory_bot/sequence"
require "factory_bot/attribute_list"
require "factory_bot/trait"
require "factory_bot/aliases"
require "factory_bot/definition"
require "factory_bot/definition_proxy"
require "factory_bot/syntax"
require "factory_bot/syntax_runner"
require "factory_bot/find_definitions"
require "factory_bot/reload"
require "factory_bot/decorator"
require "factory_bot/decorator/attribute_hash"
require "factory_bot/decorator/disallows_duplicates_registry"
require "factory_bot/decorator/invocation_tracker"
require "factory_bot/decorator/new_constructor"
require "factory_bot/linter"
require "factory_bot/version"
require "factory_bot/internal"

module FactoryBot
  Deprecation = ActiveSupport::Deprecation.new("6.0", "factory_bot")

  def self.configuration
    Internal.configuration
  end

  def self.reset_configuration
    Internal.reset_configuration
  end

  mattr_accessor :use_parent_strategy, instance_accessor: false
  self.use_parent_strategy = true

  # Look for errors in factories and (optionally) their traits.
  # Parameters:
  # factories - which factories to lint; omit for all factories
  # options:
  #   traits: true - to lint traits as well as factories
  #   strategy: :create - to specify the strategy for linting
  #   verbose: true - to include full backtraces for each linting error
  def self.lint(*args)
    options = args.extract_options!
    factories_to_lint = args[0] || FactoryBot.factories
    Linter.new(factories_to_lint, **options).lint!
  end

  class << self
    delegate :callbacks,
             :callback_names,
             :constructor,
             :factories,
             :initialize_with,
             :sequences,
             :skip_create,
             :strategies,
             :to_create,
             :traits,
             to: :configuration

    delegate :factory_by_name,
             :register_callback,
             :register_default_callbacks,
             :register_default_strategies,
             :register_factory,
             :register_sequence,
             :register_strategy,
             :register_trait,
             :rewind_sequences,
             :sequence_by_name,
             :strategy_by_name,
             :trait_by_name,
             to: Internal

    attr_accessor :allow_class_lookup

    deprecate :allow_class_lookup,
              :allow_class_lookup=,
              :callback_names,
              :factory_by_name,
              :register_callback,
              :register_default_callbacks,
              :register_default_strategies,
              :register_factory,
              :register_trait,
              :sequence_by_name,
              :sequences,
              :strategies,
              :trait_by_name,
              :traits,
              deprecator: Deprecation
  end
end

FactoryBot::Internal.register_default_strategies
FactoryBot::Internal.register_default_callbacks
