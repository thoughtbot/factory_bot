module FactoryBot
  module Internal
    module Sequences
      def self.sequences
        @sequences ||= Decorator::DisallowsDuplicatesRegistry.new(Registry.new("Sequence"))
      end

      def self.inline_sequences
        @inline_sequences ||= []
      end

      def self.reset
        @sequences&.reset
        @inline_sequences = []
        sequences
      end

      def self.register_inline_sequence(sequence)
        inline_sequences.push(sequence)
        sequence
      end

      def self.rewind_inline_sequences
        inline_sequences.each(&:rewind)
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

      def self.rewind_sequences
        sequences.each(&:rewind)
        rewind_inline_sequences
      end

      def self.rewind_sequence(*uri_parts)
        fail_argument_count(0, "1+") if uri_parts.empty?

        uri = build_uri(uri_parts)
        sequence = Sequence.find_by_uri(uri) || fail_unregistered_sequence(uri)

        sequence.rewind
      end

      def self.set_sequence(*uri_parts, value)
        uri = build_uri(uri_parts) || fail_argument_count(uri_parts.size, "2+")
        sequence = Sequence.find(*uri) || fail_unregistered_sequence(uri)

        sequence.set_value(value)
      end

      def self.build_uri(...)
        FactoryBot::UriManager.build_uri(...)
      end
      private_class_method :build_uri

      def self.fail_argument_count(received, expected)
        fail ArgumentError,
          "wrong number of arguments (given #{received}, expected #{expected})"
      end
      private_class_method :fail_argument_count

      def self.fail_unregistered_sequence(uri)
        fail KeyError,
          "Sequence not registered: '#{uri}'."
      end
      private_class_method :fail_unregistered_sequence
    end
  end
end
