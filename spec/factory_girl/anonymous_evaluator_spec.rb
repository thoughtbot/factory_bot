require "spec_helper"

shared_examples "#set on an AnonymousEvaluator" do
  it "adds the method to the evaluator" do
    subject.set(attribute)
    subject.evaluator.new.one.should == 1
  end

  it "caches the result" do
    subject.set(attribute)
    subject.evaluator.new.tap do |obj|
      obj.one.should == 1
      obj.one.should == 1
    end
  end

  it "evaluates the block in the context of the evaluator" do
    subject.set(attribute)
    second_attribute = stub("attribute", :name => :two, :to_proc => lambda { one + 1 }, :ignored => false)
    subject.set(second_attribute)
    subject.evaluator.new.two.should == 2
  end
end

describe FactoryGirl::AnonymousEvaluator do
  its(:attributes) { should == [] }
end

describe FactoryGirl::AnonymousEvaluator, "#set" do
  let(:value) { lambda { @result ||= 0; @result += 1 } }

  context "setting an ignored attribute" do
    let(:attribute) { stub("attribute", :name => :one, :to_proc => value, :ignored => true) }

    it_behaves_like "#set on an AnonymousEvaluator"

    it "does not track the attribute" do
      subject.set(attribute)
      subject.attributes.should be_empty
    end
  end

  context "setting an attribute" do
    let(:attribute) { stub("attribute", :name => :one, :to_proc => value, :ignored => false) }

    it_behaves_like "#set on an AnonymousEvaluator"

    it "tracks the attribute" do
      subject.set(attribute)
      subject.attributes.should == [:one]
    end
  end
end
