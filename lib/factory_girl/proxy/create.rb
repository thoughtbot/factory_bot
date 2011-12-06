module FactoryGirl
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def result
        run_callbacks(:after_build)

        @to_create[result_instance]

        run_callbacks(:after_create)
        result_instance
      end
    end
  end
end
