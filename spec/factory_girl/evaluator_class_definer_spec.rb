require "spec_helper"

describe FactoryGirl::EvaluatorClassDefiner do
  let(:simple_attribute)                    { stub("simple attribute",   :name => :simple, :to_proc => lambda { 1 }) }
  let(:relative_attribute)                  { stub("relative attribute", :name => :relative, :to_proc => lambda { simple + 1 }) }
  let(:attribute_that_raises_a_second_time) { stub("attribute that would raise without a cache", :name => :raises_without_proper_cache, :to_proc => lambda { raise "failed" if @run; @run = true; nil }) }

  let(:attributes)    { [simple_attribute, relative_attribute, attribute_that_raises_a_second_time] }
  let(:class_definer) { FactoryGirl::EvaluatorClassDefiner.new(attributes) }
  let(:evaluator)     { class_definer.evaluator_class.new(stub("build strategy")) }

  it "returns an evaluator when accessing the evaluator class" do
    evaluator.should be_a(FactoryGirl::Evaluator)
  end

  it "adds each attribute to the evaluator" do
    evaluator.simple.should == 1
  end

  it "evaluates the block in the context of the evaluator" do
    evaluator.relative.should == 2
  end

  it "only instance_execs the block once even when returning nil" do
    expect {
      2.times { evaluator.raises_without_proper_cache }
    }.to_not raise_error
  end
end
