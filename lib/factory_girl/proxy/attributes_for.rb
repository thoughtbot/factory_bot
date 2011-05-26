module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def initialize(klass)
        @hash = {}
      end

      def get_attr(attribute)
        @hash[attribute]
      end

      def set_attr(attribute, value)
        @hash[attribute] = value
      end

      def result(to_create)
        @hash
      end
    end
  end
end
