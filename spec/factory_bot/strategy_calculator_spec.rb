describe FactoryBot::Strategy do
  it "returns the class passed when it is instantiated with a class" do
    strategy = define_class("MyAwesomeClass")
    result = described_class.lookup_strategy(strategy)

    expect(result).to eq strategy
  end

  it "finds the strategy by name when instantiated with a symbol" do
    strategy = define_class("MyAwesomeClass")
    allow(FactoryBot::Internal).to receive(:strategy_by_name).and_return(strategy)
    described_class.lookup_strategy(:build)

    expect(FactoryBot::Internal).to have_received(:strategy_by_name).with(:build)
  end

  it "returns the strategy found when instantiated with a symbol" do
    strategy = define_class("MyAwesomeClass")
    allow(FactoryBot::Internal).to receive(:strategy_by_name).and_return(strategy)
    result = described_class.lookup_strategy(:build)

    expect(result).to eq strategy
  end
end
