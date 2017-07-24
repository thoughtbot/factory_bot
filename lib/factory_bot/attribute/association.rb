module FactoryBot
  class Attribute
    # @api private
    class Association < Attribute
      attr_reader :factory

      def initialize(name, ignored, factory, overrides)
        super(name, ignored)
        @factory   = factory
        @overrides = overrides
      end

      def to_proc
        factory   = @factory
        overrides = @overrides
        traits_and_overrides = [factory, overrides].flatten
        factory_name = traits_and_overrides.shift

        -> { association(factory_name, *traits_and_overrides) }
      end

      def association?
        true
      end
    end
  end
end
