module FactoryBot
  Trait = Data.define(:name, :definition) do
    def self.build(name, &block)
      definition = Definition.new(name.to_s)
      DefinitionProxy.new(definition).instance_eval(&block) if block
      new(name: name.to_s, definition: definition)
    end
  end
end
