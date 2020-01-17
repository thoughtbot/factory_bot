module FactoryBot
  # @api private
  module Internal
    DEFAULT_STRATEGIES = {
      build: FactoryBot::Strategy::Build,
      create: FactoryBot::Strategy::Create,
      attributes_for: FactoryBot::Strategy::AttributesFor,
      build_stubbed: FactoryBot::Strategy::Stub,
      null: FactoryBot::Strategy::Null,
    }.freeze

    DEFAULT_CALLBACKS = [
      :after_create, :after_build, :after_stub, :after_create
    ].freeze

    class << self
      delegate :callback_names,
               :factories,
               :inline_sequences,
               :sequences,
               :strategies,
               :traits,
               to: :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def reset_configuration
        @configuration = nil
      end

      def register_inline_sequence(sequence)
        inline_sequences.push(sequence)
      end

      def rewind_inline_sequences
        inline_sequences.each(&:rewind)
      end

      def register_trait(trait)
        trait.names.each do |name|
          traits.register(name, trait)
        end
        trait
      end

      def trait_by_name(name)
        traits.find(name)
      end

      def register_sequence(sequence)
        sequence.names.each do |name|
          sequences.register(name, sequence)
        end
        sequence
      end

      def sequence_by_name(name)
        sequences.find(name)
      end

      def rewind_sequences
        sequences.each(&:rewind)
        rewind_inline_sequences
      end

      def register_factory(factory)
        factory.names.each do |name|
          factories.register(name, factory)
        end
        factory
      end

      def factory_by_name(name)
        factories.find(name)
      end

      def register_strategy(strategy_name, strategy_class)
        strategies.register(strategy_name, strategy_class)
        StrategySyntaxMethodRegistrar.new(strategy_name).define_strategy_methods
      end

      def strategy_by_name(name)
        strategies.find(name)
      end

      def register_default_strategies
        DEFAULT_STRATEGIES.each { |name, klass| register_strategy(name, klass) }
      end

      def register_default_callbacks
        DEFAULT_CALLBACKS.each(&method(:register_callback))
      end

      def register_callback(name)
        name = name.to_sym
        callback_names << name
      end
    end
  end
end
