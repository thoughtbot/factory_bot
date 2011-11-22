module FactoryGirl
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def result(to_create)
        super

        to_create[result_instance]

        run_callbacks(:after_create)
        result_instance
      end
    end
  end
end
