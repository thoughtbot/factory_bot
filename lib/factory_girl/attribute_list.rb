module FactoryGirl
  class AttributeList
    include Enumerable

    def initialize(name = nil)
      @name         = name
      @attributes   = {}
      @declarations = DeclarationList.new
      @overridable  = false
      @compiled     = false
    end

    def declare_attribute(declaration)
      @declarations << declaration
      declaration
    end

    def define_attribute(attribute)
      ensure_attribute_not_self_referencing! attribute
      ensure_attribute_not_defined! attribute

      add_attribute attribute
    end

    def each(&block)
      flattened_attributes.each(&block)
    end

    def ensure_compiled
      compile unless @compiled
    end

    def apply_attribute_list(attributes_to_apply)
      new_attributes = []

      attributes_to_apply.each do |attribute|
        new_attribute = if !overridable? && defined_attribute = find_attribute(attribute.name)
          defined_attribute
        else
          attribute
        end

        delete_attribute(attribute.name)
        new_attributes << new_attribute
      end

      prepend_attributes new_attributes
    end

    def overridable
      @compiled = false
      @overridable = true
    end

    private

    def compile
      @declarations.to_attributes.each do |attribute|
        define_attribute(attribute)
      end
      @compiled = true
    end

    def add_attribute(attribute)
      delete_attribute(attribute.name) if overridable?

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
      if !overridable? && attribute_defined?(attribute.name)
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

    def overridable?
      @overridable
    end
  end
end
