module FactoryGirl
  class Proxy
    class Stub < Proxy #:nodoc:
      @@next_id = 1000

      def initialize(klass)
        @instance = klass.new
        @instance.id = next_id
        @instance.instance_eval do
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
        @instance.send(attribute)
      end

      def set(attribute, value)
        @instance.send(:"#{attribute}=", value)

        if @instance.respond_to?(:"#{attribute}_id=") && value.respond_to?(:id)
          @instance.send(:"#{attribute}_id=", value.id)
        end
      end

      def associate(name, factory_name, overrides)
        factory = FactoryGirl.factory_by_name(factory_name)
        set(name, factory.run(Proxy::Stub, overrides))
      end

      def association(factory_name, overrides = {})
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(Proxy::Stub, overrides)
      end

      def result
        run_callbacks(:after_stub)
        @instance
      end
    end
  end
end
