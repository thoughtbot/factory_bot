module FactoryGirl
  class Decorator
    class InvocationIgnorer < Decorator
      def __invoked_methods__
        []
      end
    end
  end
end
