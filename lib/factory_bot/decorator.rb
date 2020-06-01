module FactoryBot
  class Decorator < BasicObject
    undef_method :==

    def initialize(component)
      @component = component
    end

    def method_missing(name, *args, &block) # rubocop:disable Style/MethodMissingSuper
      @component.send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      @component.respond_to?(name, true) || super
    end

    def send(symbol, *args, &block)
      __send__(symbol, *args, &block)
    end
  end
end
