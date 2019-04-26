module FactoryBot
  # @api private
  module Internal
    class << self
      delegate :inline_sequences, :sequences, :traits, to: :configuration

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
    end
  end
end
