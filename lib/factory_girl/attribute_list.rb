module FactoryGirl
  class AttributeList
    include Enumerable

    def initialize
      @attributes = []
    end

    def define_attribute(attribute)
      if attribute_defined?(attribute.name)
        raise AttributeDefinitionError, "Attribute already defined: #{attribute.name}"
      end

      @attributes << attribute
    end

    def add_callback(name, &block)
      unless valid_callback_names.include?(name.to_sym)
        raise InvalidCallbackNameError, "#{name} is not a valid callback name. Valid callback names are #{valid_callback_names.inspect}"
      end

      @attributes << Attribute::Callback.new(name.to_sym, block)
    end

    def each(&block)
      @attributes.each(&block)
    end

    def attribute_defined?(attribute_name)
      !@attributes.detect do |attribute|
        attribute.name == attribute_name &&
          !attribute.is_a?(FactoryGirl::Attribute::Callback)
      end.nil?
    end

    def apply_attributes(attributes_to_apply)
      new_attributes = []

      attributes_to_apply.each do |attribute|
        if attribute_defined?(attribute.name)
          @attributes.delete_if do |attrib|
            new_attributes << attrib.clone if attrib.name == attribute.name
          end
        else
          new_attributes << attribute.clone
        end
      end

      @attributes.unshift *new_attributes
      @attributes = @attributes.partition {|attr| attr.priority.zero? }.flatten
    end

    private

    def valid_callback_names
      [:after_build, :after_create, :after_stub]
    end
  end
end
