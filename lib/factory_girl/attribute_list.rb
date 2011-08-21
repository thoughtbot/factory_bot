module FactoryGirl
  class AttributeList
    include Enumerable

    def initialize
      @attributes = {}
    end

    def define_attribute(attribute)
      if attribute_defined?(attribute.name)
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
      !@attributes.values.flatten.detect do |attribute|
        attribute.name == attribute_name &&
          !attribute.is_a?(FactoryGirl::Attribute::Callback)
      end.nil?
    end

    def apply_attributes(attributes_to_apply)
      new_attributes = []

      attributes_to_apply.each do |attribute|
        if attribute_defined?(attribute.name)
          @attributes.each_value do |attributes|
            attributes.delete_if do |attrib|
              new_attributes << attrib.clone if attrib.name == attribute.name
            end
          end
        else
          new_attributes << attribute.clone
        end
      end

      prepend_attributes new_attributes
    end

    private

    def valid_callback_names
      [:after_build, :after_create, :after_stub]
    end

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
  end
end
