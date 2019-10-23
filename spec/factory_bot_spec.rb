describe FactoryBot do
  it "finds a registered factory", :silence_deprecation do
    factory = FactoryBot::Factory.new(:object)
    FactoryBot.register_factory(factory)

    expect(FactoryBot.factory_by_name(factory.name)).to eq factory
  end

  it "finds a registered sequence", :silence_deprecation do
    sequence = FactoryBot::Sequence.new(:email)
    FactoryBot.register_sequence(sequence)
    expect(FactoryBot.sequence_by_name(sequence.name)).to eq sequence
  end

  it "finds a registered trait", :silence_deprecation do
    trait = FactoryBot::Trait.new(:admin)
    FactoryBot.register_trait(trait)
    expect(FactoryBot.trait_by_name(trait.name)).to eq trait
  end

  it "finds a registered strategy" do
    FactoryBot.register_strategy(:strategy_name, :strategy_class)
    expect(FactoryBot.strategy_by_name(:strategy_name)).
      to eq :strategy_class
  end

  describe ".use_parent_strategy" do
    it "is true by default" do
      expect(FactoryBot.use_parent_strategy).to be true
    end
  end
end
