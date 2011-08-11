module FactoryGirl
  class Attribute

    class AttributeGroup < Attribute
      def initialize(name, factory)
        super(name)
        @factory=factory
      end

      def add_to(proxy)
        if @factory
          @factory.attribute_group_by_name(name).attributes.each { |attr| attr.add_to(proxy) }
        else
          FactoryGirl.attribute_group_by_name(name).attributes.each { |attr| attr.add_to(proxy) }
        end
      end
    end

  end
end
