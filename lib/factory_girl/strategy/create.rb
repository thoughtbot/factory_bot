module FactoryGirl
  class Strategy #:nodoc:
    class Create < Strategy #:nodoc:
      def association(factory_name, overrides = {})
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(get_method(overrides[:method]), overrides.except(:method))
      end

      def result(attribute_assigner, to_create)
        attribute_assigner.object.tap do |result_instance|
          run_callbacks(:after_build, result_instance)
          to_create[result_instance]
          run_callbacks(:after_create, result_instance)
        end
      end

      private

      def get_method(method)
        case method
        when :build  then Strategy::Build
        when :create then Strategy::Create
        when nil     then Strategy::Create
        else raise "unrecognized method #{method}"
        end
      end
    end
  end
end
