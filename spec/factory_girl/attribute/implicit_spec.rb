require 'spec_helper'

describe FactoryGirl::Attribute::Implicit do
  let(:name)  { :author }
  let(:proxy) { stub("proxy") }
  subject     { FactoryGirl::Attribute::Implicit.new(name) }

  its(:name) { should == name }

  context "with a known factory" do
    before do
      FactoryGirl.factories.stubs(:registered? => true)
    end

    it { should be_association }

    its(:factory) { should == name }

    it "associates the factory" do
      proxy.stubs(:associate)
      subject.add_to(proxy)
      proxy.should have_received(:associate).with(name, name, {})
    end
  end

  context "with a known sequence" do
    let(:sequence) { FactoryGirl::Sequence.new(name, 1) { "magic" } }
    before         { FactoryGirl.register_sequence(sequence) }

    it { should_not be_association }

    it "generates the sequence" do
      proxy.stubs(:set)
      subject.add_to(proxy)
      proxy.should have_received(:set).with(name, "magic")
    end
  end
end
