module FactoryBot
  module Strategy
    class Create
      def association(runner)
        runner.run
      end

      def result(evaluation)
        instance = evaluation.object
        evaluation.notify(:after_build, instance)
        evaluation.notify(:before_create, instance)
        instance = evaluation.create(instance)
        evaluation.notify(:after_create, instance)
        instance
      end
    end
  end
end
