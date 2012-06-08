module FactoryGirl
  class Decorator
    class AttributeHash < Decorator
      def initialize(component, attributes = [])
        super(component)
        @attributes = attributes
      end

      def attributes
        @attributes.inject({}) do |result, attribute_name|
          result[attribute_name] = send(attribute_name)
          result
        end
      end
    end
  end
end
