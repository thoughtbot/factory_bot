module FactoryGirl
  class AttributeList
    include Enumerable

    def initialize(name = nil)
      @name       = name
      @attributes = {}
    end

    def define_attribute(attribute)
      ensure_attribute_not_self_referencing! attribute
      ensure_attribute_not_defined! attribute

      add_attribute attribute
    end

    def each(&block)
      flattened_attributes.each(&block)
    end

    def apply_attributes(attributes_to_apply)
      new_attributes = []

      attributes_to_apply.each do |attribute|
        new_attribute = find_attribute(attribute.name) || attribute
        delete_attribute(attribute.name)
        new_attributes << new_attribute
      end

      prepend_attributes new_attributes
    end

    private

    def add_attribute(attribute)
      @attributes[attribute.priority] ||= []
      @attributes[attribute.priority] << attribute
      attribute
    end

    def prepend_attributes(new_attributes)
      new_attributes.group_by {|attr| attr.priority }.each do |priority, attributes|
        @attributes[priority] ||= []
        @attributes[priority].unshift *attributes
      end
    end

    def flattened_attributes
      @attributes.keys.sort.inject([]) do |result, key|
        result << @attributes[key]
        result
      end.flatten
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
      @attributes.values.flatten.detect do |attribute|
        attribute.name == attribute_name
      end
    end

    def delete_attribute(attribute_name)
      if attribute_defined?(attribute_name)
        @attributes.each_value do |attributes|
          attributes.delete_if {|attrib| attrib.name == attribute_name }
        end
      end
    end
  end
end
