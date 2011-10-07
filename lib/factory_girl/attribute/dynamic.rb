module FactoryGirl
  class Attribute #:nodoc:
    class Dynamic < Attribute  #:nodoc:
      def initialize(name, ignored, block)
        super(name, ignored)
        @block = block
      end

      def add_to(proxy)
        value = @block.arity == 1 ? @block.call(proxy) : proxy.instance_exec(&@block)
        if FactoryGirl::Sequence === value
          raise SequenceAbuseError
        end

        if @ignored
          proxy.set_ignored(name, value)
        else
          proxy.set(name, value)
        end
      end
    end
  end
end
