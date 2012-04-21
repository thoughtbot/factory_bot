module FactoryGirl
  class StrictRegistry
    def initialize(component)
      @component = component
    end

    delegate :each, :registered?, :clear, to: :@component

    def register(name, item)
      if registered?(name)
        raise DuplicateDefinitionError, "#{@component.name} already registered: #{name}"
      else
        @component.register(name, item)
      end
    end

    def find(name)
      if registered?(name)
        @component.find(name)
      else
        raise ArgumentError, "#{@component.name} not registered: #{name}"
      end
    end
  end
end
