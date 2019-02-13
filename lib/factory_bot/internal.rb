module FactoryBot
  # @api private
  module Internal
    class << self
      delegate :inline_sequences, to: :configuration

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
    end
  end
end
