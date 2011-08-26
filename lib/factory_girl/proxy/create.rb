module FactoryGirl
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def result(to_create)
        run_callbacks(:after_build)
        if to_create
          to_create.call(@instance)
        else
          @instance.save!
        end
        run_callbacks(:after_create)
        @instance
      end

      def get_method(method_string)
        # Leaving this as Proxy::Build in the :method => :build case
        # is a bit strange, but does it have any user-visible behaviors?
        parse_method(method_string)
      end
    end
  end
end
