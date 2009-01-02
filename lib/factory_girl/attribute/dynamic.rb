class Factory
  class Attribute #:nodoc:

    class Dynamic < Attribute  #:nodoc:

      def initialize(name, block)
        super(name)
        @block = block
      end

      def add_to(proxy)
        proxy.set(name, @block.call(proxy))
      end
    end

  end
end
