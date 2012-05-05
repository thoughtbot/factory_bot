module FactoryGirl
  class Attribute
    # @api private
    class Association < Attribute
      attr_reader :factory

      def initialize(name, factory, overrides)
        super(name, false)
        @factory   = factory
        @overrides = overrides
      end

      def to_proc
        factory   = @factory
        overrides = @overrides
        -> { association(factory, overrides) }
      end

      def association?
        true
      end
    end
  end
end
