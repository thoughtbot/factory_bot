module FactoryGirl
  class Proxy #:nodoc:
    class Build < Proxy #:nodoc:
      def association(factory_name, overrides = {})
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(get_method(overrides[:method]), overrides.except(:method))
      end

      def result(to_create)
        run_callbacks(:after_build)
        result_instance
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
