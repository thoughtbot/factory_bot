module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def initialize(klass, callbacks = [])
        super
        @hash = {}
      end

      def get(attribute)
        @ignored_attributes[attribute] || @hash[attribute]
      end

      def set(attribute, value)
        return if attribute.is_a? Attribute::Association

        @hash[attribute.name] = value
      end

      def result(to_create)
        @hash
      end
    end
  end
end
