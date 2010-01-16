class Factory 
  class Proxy
    class Stub < Proxy #:nodoc:
      @@next_id = 1000

      ERROR_MESSAGE = "stubbed models are not allowed to access teh database"

      def initialize(klass)
        @instance = klass.new
        @instance.id = next_id
        @instance.instance_eval do
          def new_record?
            id.nil?
          end

          def connection
            raise ERROR_MESSAGE
          end

          def class
            klass = super.dup
            klass.instance_eval do
              def active_relation
                raise ERROR_MESSAGE
              end
            end
            klass
          end

          def reload
            raise ERROR_MESSAGE
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
      end

      def associate(name, factory, attributes)
        set(name, Factory.stub(factory, attributes))
      end

      def association(factory, overrides = {})
        Factory.stub(factory, overrides)
      end

      def result
        run_callbacks(:after_stub)
        @instance
      end
    end
  end
end
