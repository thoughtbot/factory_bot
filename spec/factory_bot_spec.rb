describe FactoryBot do
  it "finds a registered strategy" do
    FactoryBot.register_strategy(:strategy_name, :strategy_class)
    expect(FactoryBot.strategy_by_name(:strategy_name))
      .to eq :strategy_class
  end

  describe ".use_parent_strategy" do
    it "is true by default" do
      expect(FactoryBot.use_parent_strategy).to be true
    end
  end

  describe ".reload" do
    it "does not reset the value of use_parent_strategy" do
      custom_strategy = :custom_use_parent_strategy_value

      with_temporary_assignment(FactoryBot, :use_parent_strategy, custom_strategy) do
        FactoryBot.reload
        expect(FactoryBot.use_parent_strategy).to eq custom_strategy
      end
    end
  end
end
