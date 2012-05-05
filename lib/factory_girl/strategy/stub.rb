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
          evaluation.notify(:after_stub, instance)
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

          def created_at
            @created_at ||= Time.now
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
      end
    end
  end
end
