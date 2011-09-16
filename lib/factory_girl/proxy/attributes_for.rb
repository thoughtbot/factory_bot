module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def initialize(klass)
        super(klass)
        @hash = {}
        @ignored_attributes = {}
      end

      def get(attribute)
        @ignored_attributes[attribute] || @hash[attribute]
      end

      def set(attribute, value, ignored = false)
        if ignored
          @ignored_attributes[attribute] = value
        else
          @hash[attribute] = value
        end
      end

      def result(to_create)
        @hash
      end
    end
  end
end
