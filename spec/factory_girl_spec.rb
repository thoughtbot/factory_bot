require "spec_helper"

describe FactoryWoman do
  let(:factory)  { FactoryWoman::Factory.new(:object) }
  let(:sequence) { FactoryWoman::Sequence.new(:email) }
  let(:trait)    { FactoryWoman::Trait.new(:admin) }

  it "finds a registered factory" do
    FactoryWoman.register_factory(factory)
    FactoryWoman.factory_by_name(factory.name).should == factory
  end

  it "finds a registered sequence" do
    FactoryWoman.register_sequence(sequence)
    FactoryWoman.sequence_by_name(sequence.name).should == sequence
  end

  it "finds a registered trait" do
    FactoryWoman.register_trait(trait)
    FactoryWoman.trait_by_name(trait.name).should == trait
  end
end
