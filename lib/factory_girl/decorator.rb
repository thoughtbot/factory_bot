module FactoryGirl
  class Decorator < BasicObject

    autoload :AttributeHash, 'factory_girl/decorator/attribute_hash'
    autoload :ClassKeyHash, 'factory_girl/decorator/class_key_hash'
    autoload :DisallowsDuplicatesRegistry, 'factory_girl/decorator/disallows_duplicates_registry'
    autoload :InvocationTracker, 'factory_girl/decorator/invocation_tracker'
    autoload :NewConstructor, 'factory_girl/decorator/new_constructor'

    undef_method :==

    def initialize(component)
      @component = component
    end

    def method_missing(name, *args, &block)
      @component.send(name, *args, &block)
    end

    def send(symbol, *args)
      __send__(symbol, *args)
    end

    def self.const_missing(name)
      ::Object.const_get(name)
    end
  end
end
