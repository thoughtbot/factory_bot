module FactoryGirl
  class AttributeList
    include Enumerable

    attr_reader :callbacks, :declarations

    def initialize
      @attributes  = {}
      @declarations = []
      @overridable = false
      @callbacks = []
    end

    def declare_attribute(declaration)
      @declarations << declaration
      declaration
    end

    def define_attribute(attribute)
      if !overridable? && attribute_defined?(attribute.name)
        raise AttributeDefinitionError, "Attribute already defined: #{attribute.name}"
      end

      add_attribute attribute
    end

    def add_callback(callback)
      @callbacks << callback
    end

    def each(&block)
      flattened_attributes.each(&block)
    end

    def apply_attributes(attributes_to_apply)
      attributes_to_apply.callbacks.reverse.each { |callback| prepend_callback(callback) }
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
      @overridable = true
    end

    def overridable?
      @overridable
    end

    def size
      to_a.size
    end

    private

    def add_attribute(attribute)
      delete_attribute(attribute.name) if overridable?

      @attributes[attribute.priority] ||= []
      @attributes[attribute.priority] << attribute
      attribute
    end

    def prepend_callback(callback)
      @callbacks.unshift(callback)
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
