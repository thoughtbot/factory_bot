module FactoryGirl
  class Attribute #:nodoc:
    class Dynamic < Attribute  #:nodoc:
      def initialize(name, ignored, block)
        super(name, ignored)
        @block = block
      end

      def to_proc(proxy)
        block = @block

        lambda {
          value = block.arity == 1 ? block.call(proxy) : proxy.instance_exec(&block)
          raise SequenceAbuseError if FactoryGirl::Sequence === value
          value
        }
      end
    end
  end
end
