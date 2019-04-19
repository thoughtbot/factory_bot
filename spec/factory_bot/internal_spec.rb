describe FactoryBot::Internal do
  describe ".register_trait" do
    it "registers the provided trait" do
      trait = FactoryBot::Trait.new(:admin)
      configuration = FactoryBot::Internal.configuration
      expect { FactoryBot::Internal.register_trait(trait) }.
        to change { configuration.traits.count }.
        from(0).
        to(1)
    end
  end

  describe ".trait_by_name" do
    it "finds a previously registered trait" do
      trait = FactoryBot::Trait.new(:admin)
      FactoryBot::Internal.register_trait(trait)
      expect(FactoryBot::Internal.trait_by_name(trait.name)).to eq trait
    end
  end
end
