require 'spec_helper'

describe FactoryGirl::Declaration::Implicit do
  let(:name)      { :author }
  let(:proxy)     { stub("proxy") }
  subject         { FactoryGirl::Declaration::Implicit.new(name) }
  let(:attribute) { subject.to_attributes.first }

  context "with a known factory" do
    before do
      FactoryGirl.factories.stubs(:registered? => true)
    end

    it "generates an association" do
      attribute.should be_association
    end

    it "generates an association with the correct factory" do
      attribute.factory.should == name
    end

    it "associates the factory" do
      proxy.stubs(:associate)
      attribute.add_to(proxy)
      proxy.should have_received(:associate).with(name, name, {})
    end
  end

  context "with a known sequence" do
    let(:sequence) { FactoryGirl::Sequence.new(name, 1) { "magic" } }
    before         { FactoryGirl.register_sequence(sequence) }

    it "doesn't generate an association" do
      attribute.should_not be_association
    end

    it "generates the sequence" do
      proxy.stubs(:set)
      attribute.add_to(proxy)
      proxy.should have_received(:set).with(name, "magic")
    end
  end
end
