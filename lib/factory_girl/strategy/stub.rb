module FactoryGirl
  module Strategy
    class Stub
      @@next_id = 1000

      def association(runner)
        runner.run(:build_stubbed)
      end

      def result(evaluation)
        evaluation.object.tap do |instance|
          stub_database_interaction_on_result(instance)
          clear_changed_attributes_on_result(instance)
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

          def save(*args)
            raise "stubbed models are not allowed to access the database - #{self.class.to_s}#save(#{args.join(",")})"
          end

          def destroy(*args)
            raise "stubbed models are not allowed to access the database - #{self.class.to_s}#destroy(#{args.join(",")})"
          end

          def connection
            raise "stubbed models are not allowed to access the database - #{self.class.to_s}#connection()"
          end

          def reload(*args)
            raise "stubbed models are not allowed to access the database - #{self.class.to_s}#reload()"
          end

          def update_attribute(*args)
            raise "stubbed models are not allowed to access the database - #{self.class.to_s}#update_attribute(#{args.join(",")})"
          end

          def update_column(*args)
            raise "stubbed models are not allowed to access the database - #{self.class.to_s}#update_column(#{args.join(",")})"
          end

          def increment!(*args)
            raise "stubbed models are not allowed to access the database - #{self.class}#increment!(#{args.join(',')})"
          end

          def decrement!(*args)
            raise "stubbed models are not allowed to access the database - #{self.class}#decrement!(#{args.join(',')})"
          end
        end

        created_at_missing_default = result_instance.respond_to?(:created_at) && !result_instance.created_at
        result_instance_missing_created_at = !result_instance.respond_to?(:created_at)

        if created_at_missing_default || result_instance_missing_created_at
          result_instance.instance_eval do
            def created_at
              @created_at ||= Time.now.in_time_zone
            end
          end
        end
      end

      def clear_changed_attributes_on_result(result_instance)
        unless result_instance.respond_to?(:clear_changes_information)
          result_instance.extend ActiveModelDirtyBackport
        end

        result_instance.clear_changes_information
      end
    end

    module ActiveModelDirtyBackport
      def clear_changes_information
        @previously_changed = ActiveSupport::HashWithIndifferentAccess.new
        @changed_attributes = ActiveSupport::HashWithIndifferentAccess.new
      end
    end
  end
end
