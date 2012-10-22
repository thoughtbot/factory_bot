require "spec_helper"

describe FactoryGirl::EvaluatorClassDefiner do
  it "returns an evaluator when accessing the evaluator class" do
    evaluator = define_evaluator(parent_class: FactoryGirl::Evaluator)

    evaluator.should be_a(FactoryGirl::Evaluator)
  end

  it "adds each attribute to the evaluator" do
    attribute = stub_attribute(:attribute) { 1 }
    evaluator = define_evaluator(attributes: [attribute])

    evaluator.attribute.should == 1
  end

  it "evaluates the block in the context of the evaluator" do
    dependency_attribute = stub("dependency", name: :dependency, to_proc: -> { 1 })
    dependency_attribute = stub_attribute(:dependency) { 1 }
    attribute = stub_attribute(:attribute) { dependency + 1 }
    evaluator = define_evaluator(attributes: [dependency_attribute, attribute])

    evaluator.attribute.should == 2
  end

  it "only instance_execs the block once even when returning nil" do
    count = 0
    attribute = stub_attribute :attribute do
      count += 1
      nil
    end
    evaluator = define_evaluator(attributes: [attribute])

    2.times { evaluator.attribute }

    count.should == 1
  end

  it "sets attributes on the evaluator class" do
    attributes = [stub_attribute, stub_attribute]
    evaluator = define_evaluator(attributes: attributes)

    evaluator.attribute_lists.should == [attributes]
  end

  context "with a custom evaluator as a parent class" do
    it "bases its attribute lists on itself and its parent evaluator" do
      parent_attributes = [stub_attribute, stub_attribute]
      parent_evaluator_class = define_evaluator_class(attributes: parent_attributes)
      child_attributes = [stub_attribute, stub_attribute]
      child_evaluator = define_evaluator(
        attributes: child_attributes,
        parent_class: parent_evaluator_class
      )

      child_evaluator.attribute_lists.
        should == [parent_attributes, child_attributes]
    end
  end

  def define_evaluator(arguments = {})
    evaluator_class = define_evaluator_class(arguments)
    evaluator_class.new(FactoryGirl::Strategy::Null)
  end

  def define_evaluator_class(arguments = {})
    evaluator_class_definer = FactoryGirl::EvaluatorClassDefiner.new(
      arguments[:attributes] || [],
      arguments[:parent_class] || FactoryGirl::Evaluator
    )
    evaluator_class_definer.evaluator_class
  end

  def stub_attribute(name = :attribute, &value)
    value ||= -> {}
    stub(name.to_s, name: name.to_sym, to_proc: value)
  end
end
