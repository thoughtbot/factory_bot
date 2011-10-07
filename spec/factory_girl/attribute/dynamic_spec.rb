require 'spec_helper'

describe FactoryGirl::Attribute::Dynamic do
  let(:name)  { :first_name }
  let(:proxy) { stub("proxy", :set => nil) }
  let(:block) { lambda { } }

  subject { FactoryGirl::Attribute::Dynamic.new(name, false, block) }

  its(:name) { should == name }

  context "with a block returning a static value" do
    let(:block) { lambda { "value" } }

    it "calls the block to set a value" do
      subject.add_to(proxy)
      proxy.should have_received(:set).with(name, "value")
    end
  end

  context "with a block returning its block-level variable" do
    let(:block) { lambda {|thing| thing } }

    it "yields the proxy to the block" do
      subject.add_to(proxy)
      proxy.should have_received(:set).with(name, proxy)
    end
  end

  context "with a block referencing an attribute on the proxy" do
    let(:block)  { lambda { attribute_defined_on_proxy } }
    let(:result) { "other attribute value" }

    before do
      proxy.stubs(:attribute_defined_on_proxy => result)
    end

    it "evaluates the attribute from the proxy" do
      subject.add_to(proxy)
      proxy.should have_received(:set).with(name, result)
    end
  end

  context "with a block returning a sequence" do
    let(:block) { lambda { Factory.sequence(:email) } }

    it "raises a sequence abuse error" do
      expect { subject.add_to(proxy) }.to raise_error(FactoryGirl::SequenceAbuseError)
    end
  end
end

describe FactoryGirl::Attribute::Dynamic, "with a string name" do
  subject    { FactoryGirl::Attribute::Dynamic.new("name", nil, false) }
  its(:name) { should == :name }
end
