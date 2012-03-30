module FactoryGirl
  class Strategy #:nodoc:
    class AttributesFor < Strategy #:nodoc:
      def association(runner)
        runner.run(Strategy::Null)
      end

      def result(attribute_assigner, to_create)
        attribute_assigner.hash
      end
    end
  end
end
