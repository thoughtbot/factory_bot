module FactoryGirl
  class Decorator < BasicObject
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
  end
end
