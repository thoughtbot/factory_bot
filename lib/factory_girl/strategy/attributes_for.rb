module FactoryGirl
  class Strategy #:nodoc:
    class AttributesFor < Strategy #:nodoc:
      def association(runner)
      end

      def association_list(runner, amount)
      end

      def result(attribute_assigner, to_create)
        attribute_assigner.hash
      end
    end
  end
end
