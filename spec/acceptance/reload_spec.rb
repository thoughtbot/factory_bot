describe "reload" do
  it "does not reset the value of use_parent_strategy" do
    custom_strategy = :custom_use_parent_strategy_value

    with_temporary_assignment(FactoryBot, :use_parent_strategy, custom_strategy) do
      FactoryBot.reload
      expect(FactoryBot.use_parent_strategy).to eq custom_strategy
    end
  end
end
