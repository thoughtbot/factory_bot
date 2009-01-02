class Factory

  class AttributeDefinitionError < RuntimeError
  end
  
  class Attribute #:nodoc:

    attr_reader :name

    def initialize(name)
      @name = name.to_sym

      if @name.to_s =~ /=$/
        raise AttributeDefinitionError, 
          "factory_girl uses 'f.#{@name.to_s.chop} value' syntax " +
          "rather than 'f.#{@name} = value'" 
      end
    end

    def add_to(proxy)
    end
  end

end
