module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def result(attribute_assigner)
        attribute_assigner.hash
      end
    end
  end
end
