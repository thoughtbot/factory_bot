module FactoryGirl
  class Strategy #:nodoc:
    class Create < Strategy #:nodoc:
      def association(runner, overrides)
        runner.run(overrides[:method], overrides)
      end

      def result(attribute_assigner, to_create)
        attribute_assigner.object.tap do |result_instance|
          run_callbacks(:after_build, result_instance)
          to_create[result_instance]
          run_callbacks(:after_create, result_instance)
        end
      end
    end
  end
end
