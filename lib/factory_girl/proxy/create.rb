module FactoryGirl
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def result(to_create)
        super

        to_create ||= lambda {|instance| instance.save! }
        to_create[@instance]

        run_callbacks(:after_create)
        @instance
      end
    end
  end
end
