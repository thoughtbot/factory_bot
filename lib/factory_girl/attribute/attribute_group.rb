module FactoryGirl
  class Attribute

    class AttributeGroup < Attribute
      def initialize(name, factory)
        super(name)
        @factory = factory
      end

      def add_to(proxy)
        attribute_group.attributes.each { |attr| attr.add_to(proxy) }
      end

      private

      def attribute_group
        (@factory || FactoryGirl).attribute_group_by_name(name)
      end
    end
  end
end
