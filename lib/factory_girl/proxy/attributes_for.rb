module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def result(attribute_assigner, to_create)
        attribute_assigner.hash
      end
    end
  end
end
