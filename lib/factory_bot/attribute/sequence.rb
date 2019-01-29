module FactoryGirl
  class Attribute
    # @api private
    class Sequence < Attribute
      def initialize(name, sequence, ignored)
        super(name, ignored)
        @sequence = sequence
      end

      def to_proc
        sequence = @sequence
        -> { FactoryGirl.generate(sequence) }
      end
    end
  end
end
