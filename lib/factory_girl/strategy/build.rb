class Factory
  class Strategy #:nodoc:
    class Build < Strategy
      def initialize(klass)
        @instance = klass.new
      end

      def get(attribute)
        @instance.send(attribute)
      end

      def set(attribute, value)
        @instance.send(:"#{attribute}=", value)
      end

      def associate(name, factory, attributes)
        set(name, Factory.create(factory, attributes))
      end

      def result
        @instance
      end
    end
  end
end
