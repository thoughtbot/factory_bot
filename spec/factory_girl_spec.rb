require "spec_helper"

describe FactoryGirl do
  let(:factory)  { FactoryGirl::Factory.new(:object) }
  let(:sequence) { FactoryGirl::Sequence.new(:email) }
  let(:trait)    { FactoryGirl::Trait.new(:admin) }

  it "finds a registered factory" do
    FactoryGirl.register_factory(factory)
    FactoryGirl.factory_by_name(factory.name).should == factory
  end

  it "finds a registered sequence" do
    FactoryGirl.register_sequence(sequence)
    FactoryGirl.sequence_by_name(sequence.name).should == sequence
  end

  it "finds a registered trait" do
    FactoryGirl.register_trait(trait)
    FactoryGirl.trait_by_name(trait.name).should == trait
  end
end
