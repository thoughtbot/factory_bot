class Factory
  class Attribute #:nodoc:

    class Association < Attribute  #:nodoc:

      def initialize(name, factory, overrides)
        super(name)
        @factory   = factory
        @overrides = overrides
      end

      def add_to(proxy)
        proxy.associate(name, @factory, @overrides)
      end
    end

  end
end
