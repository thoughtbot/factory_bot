module FactoryGirl
  class AttributeList
    include Enumerable

    def initialize
      @attributes  = {}
      @overridable = false
    end

    def define_attribute(attribute)
      if !overridable? && attribute_defined?(attribute.name)
        raise AttributeDefinitionError, "Attribute already defined: #{attribute.name}"
      end

      add_attribute attribute
    end

    def add_callback(name, &block)
      unless valid_callback_names.include?(name.to_sym)
        raise InvalidCallbackNameError, "#{name} is not a valid callback name. Valid callback names are #{valid_callback_names.inspect}"
      end

      add_attribute Attribute::Callback.new(name.to_sym, block)
    end

    def each(&block)
      flattened_attributes.each(&block)
    end

    def attribute_defined?(attribute_name)
      !!find_attribute(attribute_name)
    end

    def apply_attributes(attributes_to_apply)
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

    private

    def valid_callback_names
      [:after_build, :after_create, :after_stub]
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

    def find_attribute(attribute_name)
      @attributes.values.flatten.detect do |attribute|
        attribute.name == attribute_name &&
          !attribute.is_a?(FactoryGirl::Attribute::Callback)
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
