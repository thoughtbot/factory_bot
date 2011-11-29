require 'spec_helper'

describe FactoryGirl::Attribute::Dynamic do
  let(:name)  { :first_name }
  let(:block) { lambda { } }

  subject { FactoryGirl::Attribute::Dynamic.new(name, false, block) }

  its(:name) { should == name }

  context "with a block returning a static value" do
    let(:block) { lambda { "value" } }

    it "returns the value when executing the proc" do
      subject.to_proc.call.should == "value"
    end
  end

  context "with a block returning its block-level variable" do
    let(:block) { lambda {|thing| thing } }

    it "returns self when executing the proc" do
      subject.to_proc.call.should == subject
    end
  end

  context "with a block referencing an attribute on the attribute" do
    let(:block)  { lambda { attribute_defined_on_attribute } }
    let(:result) { "other attribute value" }

    before do
      subject.stubs(:attribute_defined_on_attribute => result)
    end

    it "evaluates the attribute from the attribute" do
      subject.to_proc.call.should == result
    end
  end

  context "with a block returning a sequence" do
    let(:block) { lambda { Factory.sequence(:email) } }

    it "raises a sequence abuse error" do
      expect { subject.to_proc.call }.to raise_error(FactoryGirl::SequenceAbuseError)
    end
  end
end

describe FactoryGirl::Attribute::Dynamic, "with a string name" do
  subject    { FactoryGirl::Attribute::Dynamic.new("name", false, lambda { } ) }
  its(:name) { should == :name }
end
