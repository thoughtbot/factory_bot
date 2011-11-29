module FactoryGirl
  class Attribute #:nodoc:
    class Association < Attribute  #:nodoc:
      attr_reader :factory

      def initialize(name, factory, overrides)
        super(name, false)
        @factory   = factory
        @overrides = overrides
      end

      def to_proc
        factory   = @factory
        overrides = @overrides
        lambda { association(factory, overrides) }
      end

      def association?
        true
      end
    end
  end
end
