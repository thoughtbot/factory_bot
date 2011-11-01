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

        set_proxy_value(proxy, value)
      end
    end
  end
end
