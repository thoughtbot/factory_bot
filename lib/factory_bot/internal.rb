module FactoryBot
  # @api private
  module Internal
    class << self
      delegate :after,
        :before,
        :callbacks,
        :constructor,
        :factories,
        :initialize_with,
        :inline_sequences,
        :sequences,
        :skip_create,
        :strategies,
        :to_create,
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
        sequence
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

      def trait_by_name(name, klass)
        traits.find(name).tap { |t| t.klass = klass }
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

      def rewind_sequence(*uri_parts)
        fail_argument_count(0, "1+") if uri_parts.empty?

        uri = build_uri(uri_parts)
        sequence = Sequence.find_by_uri(uri) || fail_unregistered_sequence(uri)

        sequence.rewind
      end

      def set_sequence(*uri_parts, value)
        uri = build_uri(uri_parts) || fail_argument_count(uri_parts.size, "2+")
        sequence = Sequence.find(*uri) || fail_unregistered_sequence(uri)

        sequence.set_value(value)
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
        register_strategy(:build, FactoryBot::Strategy::Build)
        register_strategy(:create, FactoryBot::Strategy::Create)
        register_strategy(:attributes_for, FactoryBot::Strategy::AttributesFor)
        register_strategy(:build_stubbed, FactoryBot::Strategy::Stub)
        register_strategy(:null, FactoryBot::Strategy::Null)
      end

      private

      def build_uri(...)
        FactoryBot::UriManager.build_uri(...)
      end

      def fail_argument_count(received, expected)
        fail ArgumentError,
          "wrong number of arguments (given #{received}, expected #{expected})"
      end

      def fail_unregistered_sequence(uri)
        fail KeyError,
          "Sequence not registered: '#{uri}'."
      end
    end
  end
end
