require "spec_helper"

describe FactoryGirl::AssociationRunner do
  let(:factory)  { stub("factory", :run => instance) }
  let(:instance) { stub("instance") }

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
  end

  it "passes all overrides to the factory" do
    FactoryGirl::AssociationRunner.new(:user, FactoryGirl::Strategy::Build, :method => :build, :name => "John").run
    factory.should have_received(:run).with(FactoryGirl::Strategy::Build, :method => :build, :name => "John")
  end

  it "runs a strategy inferred by name based on a factory name" do
    FactoryGirl::AssociationRunner.new(:user, :build, :method => :build, :name => "John").run
    factory.should have_received(:run).with(FactoryGirl::Strategy::Build, :method => :build, :name => "John")
  end

  it "allows overriding strategy" do
    FactoryGirl::AssociationRunner.new(:user, :build, :method => :build, :name => "John").run(FactoryGirl::Strategy::Create)
    factory.should have_received(:run).with(FactoryGirl::Strategy::Create, :method => :build, :name => "John")
  end

  it "raises if the strategy cannot be inferred" do
    expect do
      FactoryGirl::AssociationRunner.new(:user, :bogus_strategy, :method => :build, :name => "John").run
    end.to raise_error("unrecognized method bogus_strategy")
  end
end
