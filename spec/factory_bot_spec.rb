describe FactoryBot do
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

  describe ".randomise_sequence_start" do
    it "is false by default" do
      expect(FactoryBot.randomise_sequence_start).to be false
    end
  end
end
