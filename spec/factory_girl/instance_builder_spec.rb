require "spec_helper"

describe FactoryGirl::InstanceBuilder, "without a constructor block" do
  let(:result_instance) { stub("result instance") }
  let(:build_class)     { stub("build class", :new => result_instance) }
  let(:evaluator)       { stub("evaluator") }

  subject { FactoryGirl::InstanceBuilder.new(build_class) }

  it "instantiates the build class by calling #new" do
    subject.build(evaluator).should == result_instance
  end
end

describe FactoryGirl::InstanceBuilder, "with a constructor block" do
  let(:result_instance)    { stub("result instance") }
  let(:build_class)        { stub("build class", :new => result_instance) }
  let(:evaluator)          { stub("evaluator", :name => "John Doe") }

  subject do
    FactoryGirl::InstanceBuilder.new(build_class) do
      [name]
    end
  end

  it "returns the result of the constructor block evaluated in the context of the evaluator" do
    subject.build(evaluator).should == ["John Doe"]
  end

  it "does not call #new on the build class" do
    subject.build(evaluator)
    build_class.should have_received(:new).never
  end
end
