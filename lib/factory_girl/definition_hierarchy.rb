module FactoryGirl
  class DefinitionHierarchy
    def callbacks
      FactoryGirl.callbacks
    end

    def constructor
      FactoryGirl.constructor
    end

    def to_create
      FactoryGirl.to_create
    end

    def self.build_from_definition(definition)
      definition.modules.each do |mod|
        include mod
      end
    end
  end
end
