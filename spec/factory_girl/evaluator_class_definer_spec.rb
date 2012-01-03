require "spec_helper"

describe FactoryGirl::EvaluatorClassDefiner do
  let(:simple_attribute)                    { stub("simple attribute",   :name => :simple, :to_proc => lambda { 1 }) }
  let(:relative_attribute)                  { stub("relative attribute", :name => :relative, :to_proc => lambda { simple + 1 }) }
  let(:attribute_that_raises_a_second_time) { stub("attribute that would raise without a cache", :name => :raises_without_proper_cache, :to_proc => lambda { raise "failed" if @run; @run = true; nil }) }
  let(:callbacks) { [stub("callback 1"), stub("callback 2")] }

  let(:attributes)    { [simple_attribute, relative_attribute, attribute_that_raises_a_second_time] }
  let(:class_definer) { FactoryGirl::EvaluatorClassDefiner.new(attributes, callbacks, FactoryGirl::Evaluator) }
  let(:evaluator)     { class_definer.evaluator_class.new(stub("build strategy", :add_observer => true)) }

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

  it "sets attributes on the evaluator class" do
    class_definer.evaluator_class.attribute_lists.should == [attributes]
  end

  it "sets callbacks on the evaluator class" do
    class_definer.evaluator_class.callbacks.should == callbacks
  end

  context "with a custom evaluator as a parent class" do
    let(:child_callbacks)  { [stub("child callback 1"), stub("child callback 2")] }
    let(:child_attributes) { [stub("child attribute", :name => :simple, :to_proc => lambda { 1 })] }
    let(:child_definer)    { FactoryGirl::EvaluatorClassDefiner.new(child_attributes, child_callbacks, class_definer.evaluator_class) }

    subject { child_definer.evaluator_class }

    it "bases its attribute lists on itself and its parent evaluator" do
      subject.attribute_lists.should == [attributes, child_attributes]
    end

    it "bases its callbacks on itself and its parent evaluator" do
      subject.callbacks.should == callbacks + child_callbacks
    end
  end
end
