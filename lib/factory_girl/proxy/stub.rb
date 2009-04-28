class Factory 
  class Proxy
    class Stub < Proxy #:nodoc:
      @@next_id = 1000

      def initialize(klass)
        @stub = klass.new
        @stub.id = next_id
        @stub.instance_eval do
          def new_record?
            id.nil?
          end

          def connection
            raise "stubbed models are not allowed to access the database"
          end

          def reload
            raise "stubbed models are not allowed to access the database"
          end
        end
      end

      def next_id
        @@next_id += 1
      end

      def get(attribute)
        @stub.send(attribute)
      end

      def set(attribute, value)
        @stub.send(:"#{attribute}=", value)
      end

      def associate(name, factory, attributes)
        set(name, Factory.stub(factory, attributes))
      end

      def association(factory, overrides = {})
        Factory.stub(factory, overrides)
      end

      def result
        @stub
      end
    end
  end
end
