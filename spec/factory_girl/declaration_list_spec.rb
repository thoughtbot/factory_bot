require "spec_helper"

describe FactoryGirl::DeclarationList, "#to_attributes" do
  let(:static_attribute_1)  { stub("static attribute 1") }
  let(:static_attribute_2)  { stub("static attribute 2") }
  let(:dynamic_attribute_1) { stub("dynamic attribute 1") }
  let(:static_declaration)  { stub("static declaration", :to_attributes => [static_attribute_1, static_attribute_2]) }
  let(:dynamic_declaration) { stub("static declaration", :to_attributes => [dynamic_attribute_1]) }

  it "returns all attributes by declaration order" do
    subject << static_declaration
    subject.to_attributes.should == [static_attribute_1, static_attribute_2]

    subject << dynamic_declaration
    subject.to_attributes.should == [static_attribute_1, static_attribute_2, dynamic_attribute_1]
  end
end
