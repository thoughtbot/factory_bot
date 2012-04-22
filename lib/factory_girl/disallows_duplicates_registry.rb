module FactoryGirl
  class DisallowsDuplicatesRegistry
    def initialize(component)
      @component = component
    end

    delegate :clear, :each, :find, :[], :registered?, to: :@component

    def register(name, item)
      if registered?(name)
        raise DuplicateDefinitionError, "#{@component.name} already registered: #{name}"
      else
        @component.register(name, item)
      end
    end
  end
end
