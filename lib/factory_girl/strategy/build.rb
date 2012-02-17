module FactoryGirl
  class Strategy #:nodoc:
    class Build < Strategy #:nodoc:
      def association(runner)
        runner.run
      end

      def result(attribute_assigner, to_create)
        attribute_assigner.object.tap do |result_instance|
          run_callbacks(:after_build, result_instance)
        end
      end
    end
  end
end
