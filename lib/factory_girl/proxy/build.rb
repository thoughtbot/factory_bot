module FactoryGirl
  class Proxy #:nodoc:
    class Build < Proxy #:nodoc:
      def initialize(klass, callbacks = [])
        super
        @instance = klass.new
      end

      def get(attribute)
        if @ignored_attributes.has_key?(attribute)
          @ignored_attributes[attribute]
        else
          @instance.send(attribute)
        end
      end

      def set(attribute, value)
        @instance.send(:"#{attribute.name}=", value)
      end

      def association(factory_name, overrides = {})
        method = get_method(overrides[:method])
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(method, overrides.except(:method))
      end

      def result(to_create)
        run_callbacks(:after_build)
        @instance
      end

      private

      def get_method(method)
        case method
        when :build  then Proxy::Build
        when :create then Proxy::Create
        when nil     then Proxy::Create
        else raise "unrecognized method #{method}"
        end
      end
    end
  end
end
