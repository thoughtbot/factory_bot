describe "reload" do
  it "does not reset the value of use_parent_strategy" do
    use_parent_strategy = :custom_use_parent_strategy_value
    FactoryGirl.use_parent_strategy = use_parent_strategy

    FactoryGirl.reload

    expect(FactoryGirl.use_parent_strategy).to eq use_parent_strategy
  end
end
