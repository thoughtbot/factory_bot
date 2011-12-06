module FactoryGirl
  class Proxy #:nodoc:
    class AttributesFor < Proxy #:nodoc:
      def result(to_create)
        result_hash
      end
    end
  end
end
