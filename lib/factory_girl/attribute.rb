module FactoryGirl

  # Raised when defining an invalid attribute:
  # * Defining an attribute which has a name ending in "="
  # * Defining an attribute with both a static and lazy value
  # * Defining an attribute twice in the same factory
  class AttributeDefinitionError < RuntimeError
  end

  class Attribute #:nodoc:
    include Comparable

    attr_reader :name

    def initialize(name)
      @name = name.to_sym

      if @name.to_s =~ /=$/
        attribute_name = $`
        raise AttributeDefinitionError,
          "factory_girl uses 'f.#{attribute_name} value' syntax " +
          "rather than 'f.#{attribute_name} = value'"
      end
    end

    def add_to(proxy)
    end

    def association?
      false
    end

    def priority
      1
    end

    def aliases_for?(attr)
      FactoryGirl.aliases_for(attr).include?(name)
    end

    def <=>(another)
      return nil unless another.is_a? Attribute
      self.priority <=> another.priority
    end

  end

end
