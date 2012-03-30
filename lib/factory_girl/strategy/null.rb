module FactoryGirl
  class Strategy
    class Null
      def association(runner)
      end

      def result(attribute_assigner, to_create)
      end
    end
  end
end
