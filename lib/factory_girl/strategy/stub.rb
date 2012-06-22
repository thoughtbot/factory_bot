module FactoryGirl
  class Strategy
    class Stub < Strategy #:nodoc:
      @@next_id = 1000

      def association(runner)
        runner.run(Strategy::Stub)
      end

      def result(attribute_assigner, to_create)
        attribute_assigner.object.tap do |result_instance|
          stub_database_interaction_on_result(result_instance)
          run_callbacks(:after_stub, result_instance)
        end
      end

      private

      def next_id
        @@next_id += 1
      end

      def stub_database_interaction_on_result(result_instance)
        result_instance.id = next_id

        result_instance.instance_eval do
          def persisted?
            !new_record?
          end

          def new_record?
            id.nil?
          end

          def save(*args)
            raise 'stubbed models are not allowed to access the database'
          end

          def destroy(*args)
            raise 'stubbed models are not allowed to access the database'
          end

          def connection
            raise 'stubbed models are not allowed to access the database'
          end

          def reload
            raise 'stubbed models are not allowed to access the database'
          end

          def update_attribute(*args)
            raise 'stubbed models are not allowed to access the database'
          end
        end

        created_at_missing_default = result_instance.respond_to?(:created_at) && !result_instance.created_at
        result_instance_missing_created_at = !result_instance.respond_to?(:created_at)

        if created_at_missing_default || result_instance_missing_created_at
          result_instance.instance_eval do
            def created_at
              @created_at ||= Time.now
            end
          end
        end
      end
    end
  end
end
