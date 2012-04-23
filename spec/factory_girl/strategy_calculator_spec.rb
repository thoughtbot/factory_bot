require "spec_helper"

describe FactoryGirl::StrategyCalculator, "with a FactoryGirl::Strategy object" do
  let(:strategy) { FactoryGirl::Strategy::Build }

  it "returns the strategy object" do
    FactoryGirl::StrategyCalculator.new(strategy).strategy.should == strategy
  end
end

describe FactoryGirl::StrategyCalculator do
  it "returns the correct strategy object for :build" do
    FactoryGirl::StrategyCalculator.new(:build).strategy.should == FactoryGirl::Strategy::Build
  end

  it "returns the correct strategy object for :create" do
    FactoryGirl::StrategyCalculator.new(:create).strategy.should == FactoryGirl::Strategy::Create
  end

  it "raises when passing a bogus strategy" do
    expect { FactoryGirl::StrategyCalculator.new(:bogus_strategy).strategy }.to raise_error(ArgumentError, /bogus_strategy/)
  end
end
