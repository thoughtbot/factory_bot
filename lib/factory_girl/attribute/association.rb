module FactoryGirl
  class Attribute
    # @api private
    class Association < Attribute
      attr_reader :factory

      def initialize(name, factory, overrides, class_override=nil)
        super(name, false)
        @factory   = factory
        @overrides = overrides
        @class_override = class_override
      end

      def to_proc
        factory   = @factory
        overrides = @overrides
        class_override = @class_override
        traits_and_overrides = [factory, overrides].flatten
        factory_name = traits_and_overrides.shift

        -> {
          instance = association(factory_name, *traits_and_overrides)
          class_override ? instance.becomes(class_override) : instance
        }
      end

      def association?
        true
      end
    end
  end
end
