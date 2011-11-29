require "spec_helper"

describe FactoryGirl::AnonymousEvaluator do
  its(:attributes) { should == [] }
end

describe FactoryGirl::AnonymousEvaluator, "#set" do
  let(:attribute) { :one }
  let(:value)     { lambda { @result ||= 0; @result += 1 } }

  def set_attribute
    subject.set(attribute, value)
  end

  it "adds the method to the evaluator" do
    set_attribute
    subject.evaluator.new.one.should == 1
  end

  it "tracks the attribute" do
    set_attribute
    subject.attributes.should == [attribute]
  end

  it "caches the result" do
    set_attribute
    subject.evaluator.new.tap do |obj|
      obj.one.should == 1
      obj.one.should == 1
    end
  end

  it "evaluates the block in the context of the evaluator" do
    set_attribute
    subject.set(:two, lambda { one + 1 })
    subject.evaluator.new.two.should == 2
  end
end

describe FactoryGirl::AnonymousEvaluator, "#set_ignored" do
  let(:attribute) { :one }
  let(:value)     { lambda { @result ||= 0; @result += 1 } }

  def set_attribute
    subject.set_ignored(attribute, value)
  end

  it "adds the method to the evaluator" do
    set_attribute
    subject.evaluator.new.one.should == 1
  end

  it "does not track the attribute" do
    set_attribute
    subject.attributes.should == []
  end

  it "caches the result" do
    set_attribute
    subject.evaluator.new.tap do |obj|
      obj.one.should == 1
      obj.one.should == 1
    end
  end
end
