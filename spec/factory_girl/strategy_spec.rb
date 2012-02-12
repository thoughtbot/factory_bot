require 'spec_helper'

describe FactoryGirl::Strategy do
  it "raises an error when asking for the result" do
    expect { subject.result(stub("assigner"), lambda {|instance| instance }) }.to raise_error(NotImplementedError, "Strategies must return a result")
  end

  it "raises an error when asking for the association" do
    expect { subject.association(stub("runner")) }.to raise_error(NotImplementedError, "Strategies must return an association")
  end
end

describe FactoryGirl::Strategy, ".ensure_strategy_exists!" do
  it "raises when passed a nonexistent strategy" do
    expect { FactoryGirl::Strategy.ensure_strategy_exists!(:nonexistent) }.to raise_error(ArgumentError, "Unknown strategy: nonexistent")
  end

  it "doesn't raise when passed a valid strategy" do
    expect { FactoryGirl::Strategy.ensure_strategy_exists!(:create) }.to_not raise_error
  end
end
