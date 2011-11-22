module FactoryGirl
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def result(to_create)
        super

        to_create[@instance.object]

        run_callbacks(:after_create)
        @instance.object
      end
    end
  end
end
