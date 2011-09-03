module FactoryGirl
  class Attribute #:nodoc:
    class Callback < Attribute  #:nodoc:
      def initialize(name, block)
        @name  = name.to_sym
        @block = block
      end

      def add_to(proxy)
        proxy.add_callback(name, @block)
      end

      def callback?
        true
      end
    end
  end
end
