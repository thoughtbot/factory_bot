require "spec_helper"

describe FactoryGirl::AssociationRunner do
  let(:factory)  { stub("factory", :run => instance) }
  let(:instance) { stub("instance") }

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
  end

  it "runs a strategy based on a factory name" do
    FactoryGirl::AssociationRunner.new(:user).run(FactoryGirl::Strategy::Build, {})
    factory.should have_received(:run).with(FactoryGirl::Strategy::Build, {})
  end

  it "strips only method from overrides" do
    FactoryGirl::AssociationRunner.new(:user).run(FactoryGirl::Strategy::Build, { :method => :build, :name => "John" })
    factory.should have_received(:run).with(FactoryGirl::Strategy::Build, { :name => "John" })
  end

  it "runs a strategy inferred by name based on a factory name" do
    FactoryGirl::AssociationRunner.new(:user).run(:build, { :method => :build, :name => "John" })
    factory.should have_received(:run).with(FactoryGirl::Strategy::Build, { :name => "John" })
  end

  it "raises if the strategy cannot be inferred" do
    expect do
      FactoryGirl::AssociationRunner.new(:user).run(:bogus_strategy, { :method => :build, :name => "John" })
    end.to raise_error("unrecognized method bogus_strategy")
  end
end
