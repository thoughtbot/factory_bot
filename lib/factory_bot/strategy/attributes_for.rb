module FactoryBot
  module Strategy
    class AttributesFor
      # Associations are left out of the hash, so nothing is built for them.
      def association(_runner)
        nil
      end

      def result(evaluation)
        evaluation.hash
      end

      def to_sym
        :attributes_for
      end
    end
  end
end
