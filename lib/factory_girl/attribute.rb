class Factory

  class AttributeDefinitionError < RuntimeError
  end
  
  class Attribute #:nodoc:

    attr_reader :name

    def initialize (name, static_value, lazy_block)
      name = name.to_sym

      if name.to_s =~ /=$/
        raise AttributeDefinitionError, 
          "factory_girl uses 'f.#{name.to_s.chop} value' syntax " +
          "rather than 'f.#{name} = value'" 
      end

      unless static_value.nil? || lazy_block.nil?
        raise AttributeDefinitionError, "Both value and block given"
      end

      @name         = name
      @static_value = static_value
      @lazy_block   = lazy_block
    end

    def value (proxy)
      if @lazy_block.nil?
        @static_value
      else
        @lazy_block.call(proxy)
      end
    end

  end

end
