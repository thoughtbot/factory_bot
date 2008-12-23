class Factory
  class Strategy #:nodoc:
    class AttributesFor < Strategy
      def initialize(klass)
        @hash = {}
      end

      def get(attribute)
        @hash[attribute]
      end

      def set(attribute, value)
        @hash[attribute] = value
      end

      def result
        @hash
      end
    end
  end
end
