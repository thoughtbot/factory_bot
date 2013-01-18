require "spec_helper"

describe FactoryGirl::StrategyCalculator do
  let(:strategy) do
    define_class("MyAwesomeClass")
  end

  context "when a class" do
    subject { FactoryGirl::StrategyCalculator.new(strategy).strategy }

    it "returns the class passed" do
      expect(subject).to eq strategy
    end
  end

  context "when a symbol" do
    before  { FactoryGirl.stubs(:strategy_by_name).returns(strategy) }
    subject { FactoryGirl::StrategyCalculator.new(:build).strategy }

    it "finds the strategy by name" do
      subject
      expect(FactoryGirl).to have_received(:strategy_by_name).with(:build)
    end

    it "returns the strategy found" do
      expect(subject).to eq strategy
    end
  end
end
