module FactoryGirl
  class Proxy
    class Stub < Proxy #:nodoc:
      @@next_id = 1000

      def initialize(klass, callbacks = [])
        super
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
            raise "stubbed models are not allowed to access the database"
          end

          def destroy(*args)
            raise "stubbed models are not allowed to access the database"
          end

          def connection
            raise "stubbed models are not allowed to access the database"
          end

          def reload
            raise "stubbed models are not allowed to access the database"
          end

          def update_attribute(*args)
            raise "stubbed models are not allowed to access the database"
          end
        end
      end

      def association(factory_name, overrides = {})
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(Proxy::Stub, overrides.except(:method))
      end

      def result(to_create)
        run_callbacks(:after_stub)
        result_instance
      end

      private

      def next_id
        @@next_id += 1
      end
    end
  end
end
