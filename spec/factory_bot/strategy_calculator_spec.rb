describe FactoryBot::StrategyCalculator do
  let(:strategy) do
    define_class("MyAwesomeClass")
  end

  context "when a class" do
    subject { FactoryBot::StrategyCalculator.new(strategy).strategy }

    it "returns the class passed" do
      expect(subject).to eq strategy
    end
  end

  context "when a symbol" do
    before do
      allow(FactoryBot).to receive(:strategy_by_name).and_return(strategy)
    end

    subject { FactoryBot::StrategyCalculator.new(:build).strategy }

    it "finds the strategy by name" do
      subject
      expect(FactoryBot).to have_received(:strategy_by_name).with(:build)
    end

    it "returns the strategy found" do
      expect(subject).to eq strategy
    end
  end
end
