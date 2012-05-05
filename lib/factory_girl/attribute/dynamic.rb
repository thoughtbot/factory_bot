module FactoryGirl
  class Attribute
    # @api private
    class Dynamic < Attribute
      def initialize(name, ignored, block)
        super(name, ignored)
        @block = block
      end

      def to_proc
        block = @block

        -> {
          value = block.arity == 1 ? block.call(self) : instance_exec(&block)
          raise SequenceAbuseError if FactoryGirl::Sequence === value
          value
        }
      end
    end
  end
end
