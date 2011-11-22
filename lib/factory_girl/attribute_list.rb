module FactoryGirl
  class AttributeList
    include Enumerable

    def initialize(name = nil)
      @name       = name
      @attributes = []
    end

    def define_attribute(attribute)
      ensure_attribute_not_self_referencing! attribute
      ensure_attribute_not_defined! attribute

      add_attribute attribute
    end

    def each(&block)
      @attributes.each(&block)
    end

    def apply_attributes(attributes_to_apply)
      attributes_to_apply.each do |attribute|
        new_attribute = find_attribute(attribute.name) || attribute
        delete_attribute(attribute.name)

        add_attribute new_attribute
      end
    end

    private

    def add_attribute(attribute)
      @attributes << attribute
      attribute
    end

    def ensure_attribute_not_defined!(attribute)
      if attribute_defined?(attribute.name)
        raise AttributeDefinitionError, "Attribute already defined: #{attribute.name}"
      end
    end

    def ensure_attribute_not_self_referencing!(attribute)
      if attribute.respond_to?(:factory) && attribute.factory == @name
        raise AssociationDefinitionError, "Self-referencing association '#{attribute.name}' in '#{attribute.factory}'"
      end
    end

    def attribute_defined?(attribute_name)
      !!find_attribute(attribute_name)
    end

    def find_attribute(attribute_name)
      @attributes.detect do |attribute|
        attribute.name == attribute_name
      end
    end

    def delete_attribute(attribute_name)
      @attributes.delete_if {|attrib| attrib.name == attribute_name }
    end
  end
end
