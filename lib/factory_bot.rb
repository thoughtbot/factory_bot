require "securerandom"
require "zeitwerk"
require "active_support"
require "active_support/notifications"
require "active_support/inflector"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/time/calculations"

require_relative "factory_bot/version"
require_relative "factory_bot/errors"

loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.ignore("#{__dir__}/factory_bot/version.rb")
loader.ignore("#{__dir__}/factory_bot/errors.rb")
loader.inflector.inflect("dsl" => "DSL")
loader.setup

module FactoryBot
  extend FindDefinitions
  extend DSL
  extend Syntax::Methods

  mattr_accessor :automatically_define_enum_traits, instance_accessor: false
  self.automatically_define_enum_traits = true

  # Associations always use the parent's strategy. The writer stays so that
  # existing setup files keep loading; only the legacy `false` mode is gone.
  def self.use_parent_strategy
    true
  end

  def self.use_parent_strategy=(value)
    return if value

    raise ArgumentError, "FactoryBot.use_parent_strategy = false is no longer supported; " \
      "associations always use the parent strategy"
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def reset_configuration
      @configuration = nil
    end

    def factories = configuration.factories

    def sequences = configuration.sequences

    def traits = configuration.traits

    def strategies = configuration.strategies

    def register_strategy(name, strategy_class)
      strategies.register(name, strategy_class, replace: true)
      Syntax::Methods.define_strategy(name)
    end

    def strategy_by_name(name)
      strategies.find(name)
    end

    def register_default_strategies
      register_strategy(:build, Strategy::Build)
      register_strategy(:create, Strategy::Create)
      register_strategy(:attributes_for, Strategy::AttributesFor)
      register_strategy(:build_stubbed, Strategy::Stub)
    end

    # The first id handed out by build_stubbed.
    def build_stubbed_starting_id=(starting_id)
      Strategy::Stub.next_id = starting_id - 1
    end

    # Raises InvalidFactoryError listing every factory (and, with
    # traits: true, every trait) that fails to run with the given strategy.
    def lint(factories = nil, strategy: :create, traits: false, verbose: false)
      Linter.new(factories || self.factories, strategy: strategy, traits: traits, verbose: verbose).lint!
    end

    def rewind_sequences
      sequences.each(&:rewind)
      configuration.inline_sequences.each(&:rewind)
    end
  end
end

FactoryBot.register_default_strategies
