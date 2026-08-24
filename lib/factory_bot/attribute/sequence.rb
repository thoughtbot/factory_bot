module FactoryBot
  class Attribute
    # @api private
    class Sequence < Attribute
      def initialize(name, sequence, transient)
        super(name, transient)
        @sequence = sequence
      end

      def to_proc
        sequence = @sequence
        -> { FactoryBot.generate(sequence) }
      end
    end
  end
end
