module FactoryGirl
  class Attribute #:nodoc:

    class Dynamic < Attribute  #:nodoc:
      def initialize(name, block)
        super(name)
        @block = block
      end

      def add_to(proxy)
        value = @block.arity == 1 ? @block.call(proxy) : proxy.instance_exec(&@block)
        if FactoryGirl::Sequence === value
          raise SequenceAbuseError
        end
        method = !ignored? ? :set : :ignore
        proxy.send(method, name, value)
      end
    end

  end
end
