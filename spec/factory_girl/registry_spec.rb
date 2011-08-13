require 'spec_helper'

describe FactoryGirl::Registry do
  let(:aliases)              { [:thing, :widget] }
  let(:sequence)             { FactoryGirl::Sequence.new(:email) { |n| "somebody#{n}@example.com" } }
  let(:factory)              { FactoryGirl::Factory.new(:object) }
  let(:other_factory)        { FactoryGirl::Factory.new(:string) }
  let(:factory_with_aliases) { FactoryGirl::Factory.new(:string, :aliases => aliases) }

  subject { FactoryGirl::Registry.new }

  it { should be_kind_of(Enumerable) }

  it "finds a registered a factory" do
    subject.add(factory)
    subject.find(factory.name).should == factory
  end

  it "raises when finding an unregistered factory" do
    expect { subject.find(:bogus) }.to raise_error(ArgumentError)
  end

  it "adds and returns a factory" do
    subject.add(factory).should == factory
  end

  it "knows that a factory is registered by symbol" do
    subject.add(factory)
    subject.should be_registered(factory.name.to_sym)
  end

  it "knows that a factory is registered by string" do
    subject.add(factory)
    subject.should be_registered(factory.name.to_s)
  end

  it "knows that a factory isn't registered" do
    subject.should_not be_registered("bogus")
  end

  it "can be accessed like a hash" do
    subject.add(factory)
    subject[factory.name].should == factory
  end

  it "iterates registered factories" do
    subject.add(factory)
    subject.add(other_factory)
    subject.to_a.should =~ [factory, other_factory]
  end

  it "iterates registered factories uniquely with aliases" do
    subject.add(factory)
    subject.add(factory_with_aliases)
    subject.to_a.should =~ [factory, factory_with_aliases]
  end

  it "registers an sequence" do
    subject.add(sequence)
    subject.find(:email).should == sequence
  end

  it "doesn't allow a duplicate name" do
    expect { 2.times { subject.add(factory) } }.
      to raise_error(FactoryGirl::DuplicateDefinitionError)
  end

  it "registers aliases" do
    subject.add(factory_with_aliases)
    aliases.each do |name|
      subject.find(name).should == factory_with_aliases
    end
  end

  it "clears registered factories" do
    subject.add(factory)
    subject.clear
    subject.count.should be_zero
  end
end
