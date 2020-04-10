describe FactoryBot::StrategyCalculator do
  it "returns the class passed when it is instantiated with a class" do
    strategy = define_class("MyAwesomeClass")
    calculator = FactoryBot::StrategyCalculator.new(strategy).strategy

    expect(calculator).to eq strategy
  end

  it "finds the strategy by name when instantiated with a symbol" do
    strategy = define_class("MyAwesomeClass")
    allow(FactoryBot::Internal).to receive(:strategy_by_name).and_return(strategy)
    FactoryBot::StrategyCalculator.new(:build).strategy

    expect(FactoryBot::Internal).to have_received(:strategy_by_name).with(:build)
  end

  it "returns the strategy found when instantiated with a symbol" do
    strategy = define_class("MyAwesomeClass")
    allow(FactoryBot::Internal).to receive(:strategy_by_name).and_return(strategy)
    calculator = FactoryBot::StrategyCalculator.new(:build).strategy

    expect(calculator).to eq strategy
  end
end
