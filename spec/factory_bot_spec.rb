describe FactoryBot do
  let(:factory)  { FactoryBot::Factory.new(:object) }
  let(:sequence) { FactoryBot::Sequence.new(:email) }
  let(:trait)    { FactoryBot::Trait.new(:admin) }

  it "finds a registered factory", :silence_deprecation do
    FactoryBot.register_factory(factory)
    expect(FactoryBot.factory_by_name(factory.name)).to eq factory
  end

  it "finds a registered sequence", :silence_deprecation do
    FactoryBot.register_sequence(sequence)
    expect(FactoryBot.sequence_by_name(sequence.name)).to eq sequence
  end

  it "finds a registered trait", :silence_deprecation do
    FactoryBot.register_trait(trait)
    expect(FactoryBot.trait_by_name(trait.name)).to eq trait
  end

  describe ".use_parent_strategy" do
    it "is true by default" do
      expect(FactoryBot.use_parent_strategy).to be true
    end
  end
end
