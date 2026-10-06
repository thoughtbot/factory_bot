module FactoryBot
  # A resolved attribute. The block runs with the Evaluator as self; an
  # association has a factory name instead of a block.
  Attribute = Data.define(:name, :block, :transient, :factory, :traits, :overrides) do
    def initialize(name:, block: nil, transient: false, factory: nil, traits: [], overrides: {})
      super(name: name.to_sym, block: block, transient: transient, factory: factory, traits: traits, overrides: overrides)
    end

    def association?
      !factory.nil?
    end
  end
end
