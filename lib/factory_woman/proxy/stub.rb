module FactoryWoman
  class Proxy
    class Stub < Proxy #:nodoc:
      @@next_id = 1000

      def initialize(klass, callbacks = [])
        super
        @instance = klass.new
        @instance.id = next_id
        @instance.instance_eval do
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

      def next_id
        @@next_id += 1
      end

      def get(attribute)
        if @ignored_attributes.has_key?(attribute)
          @ignored_attributes[attribute]
        else
          @instance.send(attribute)
        end
      end

      def set(attribute, value)
        @instance.send(:"#{attribute}=", value)
      end

      def associate(name, factory_name, overrides)
        set(name, association(factory_name, overrides))
      end

      def association(factory_name, overrides = {})
        factory = FactoryWoman.factory_by_name(factory_name)
        factory.run(Proxy::Stub, overrides.except(:method))
      end

      def result(to_create)
        run_callbacks(:after_stub)
        @instance
      end
    end
  end
end
