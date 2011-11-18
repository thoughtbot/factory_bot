module FactoryWoman
  class Attribute #:nodoc:
    class Association < Attribute  #:nodoc:
      attr_reader :factory

      def initialize(name, factory, overrides)
        super(name, false)
        @factory   = factory
        @overrides = overrides
      end

      def add_to(proxy)
        proxy.associate(name, @factory, @overrides)
      end

      def association?
        true
      end
    end
  end
end
