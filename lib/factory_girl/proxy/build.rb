module FactoryGirl
  class Proxy #:nodoc:
    class Build < Proxy #:nodoc:
      def initialize(klass)
        @instance = klass.new
        @ignored_attributes = {}
      end

      def get(attribute)
        if @ignored_attributes.has_key?(attribute)
          @ignored_attributes[attribute]
        else
          @instance.send(attribute)
        end
      end

      def set(attribute, value, ignored = false)
        if ignored
          @ignored_attributes[attribute] = value
        else
          @instance.send(:"#{attribute}=", value)
        end
      end

      def associate(name, factory_name, overrides)
        factory = FactoryGirl.factory_by_name(factory_name)
        set(name, factory.run(Proxy::Create, overrides))
      end

      def association(factory_name, overrides = {})
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(Proxy::Create, overrides)
      end

      def result(to_create)
        run_callbacks(:after_build)
        @instance
      end
    end
  end
end
