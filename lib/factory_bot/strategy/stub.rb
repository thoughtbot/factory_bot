module FactoryBot
  module Strategy
    class Stub
      @@next_id = 1000

      DISABLED_PERSISTENCE_METHODS = [
        :connection,
        :decrement!,
        :delete,
        :destroy!,
        :destroy,
        :increment!,
        :reload,
        :save!,
        :save,
        :toggle!,
        :touch,
        :update!,
        :update,
        :update_attribute,
        :update_attributes!,
        :update_attributes,
        :update_column,
        :update_columns,
      ].freeze

      def association(runner)
        runner.run(:build_stubbed)
      end

      def result(evaluation)
        evaluation.object.tap do |instance|
          stub_database_interaction_on_result(instance)
          clear_changes_information(instance)
          set_timestamps(instance)
          evaluation.notify(:after_stub, instance)
        end
      end

      private

      def next_id
        @@next_id += 1
      end

      def stub_database_interaction_on_result(result_instance)
        result_instance.id ||= next_id

        result_instance.instance_eval do
          def persisted?
            !new_record?
          end

          def new_record?
            id.nil?
          end

          def destroyed?
            nil
          end

          DISABLED_PERSISTENCE_METHODS.each do |write_method|
            define_singleton_method(write_method) do |*args|
              raise "stubbed models are not allowed to access the database - #{self.class}##{write_method}(#{args.join(',')})"
            end
          end
        end
      end

      def clear_changes_information(result_instance)
        if result_instance.respond_to?(:clear_changes_information)
          result_instance.clear_changes_information
        end
      end

      def set_timestamps(result_instance)
        if missing_created_at?(result_instance)
          result_instance.created_at = Time.current
        end

        if missing_updated_at?(result_instance)
          result_instance.updated_at = Time.current
        end
      end

      def missing_created_at?(result_instance)
        result_instance.respond_to?(:created_at) &&
          result_instance.respond_to?(:created_at=) &&
          result_instance.created_at.blank?
      end

      def missing_updated_at?(result_instance)
        result_instance.respond_to?(:updated_at) &&
          result_instance.respond_to?(:updated_at=) &&
          result_instance.updated_at.blank?
      end
    end
  end
end
