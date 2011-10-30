require "spec_helper"

describe FactoryGirl::DeclarationList, "#attribute_list" do
  let(:static_attribute_1)  { stub("static attribute 1") }
  let(:static_attribute_2)  { stub("static attribute 2") }
  let(:dynamic_attribute_1) { stub("dynamic attribute 1") }
  let(:static_declaration)  { stub("static declaration", :to_attributes => [static_attribute_1, static_attribute_2]) }
  let(:dynamic_declaration) { stub("static declaration", :to_attributes => [dynamic_attribute_1]) }

  it "returns an AttributeList" do
    subject.attribute_list.should be_a(FactoryGirl::AttributeList)
  end

  let(:attribute_list) { stub("attribute list", :define_attribute => true) }

  it "defines each attribute on the attribute list" do
    FactoryGirl::AttributeList.stubs(:new => attribute_list)

    subject.declare_attribute(static_declaration)
    subject.declare_attribute(dynamic_declaration)

    subject.attribute_list

    attribute_list.should have_received(:define_attribute).with(static_attribute_1)
    attribute_list.should have_received(:define_attribute).with(static_attribute_2)
    attribute_list.should have_received(:define_attribute).with(dynamic_attribute_1)
  end

  it "creates a new attribute list upon every invocation" do
    subject.attribute_list.should_not == subject.attribute_list
  end
end

describe FactoryGirl::DeclarationList, "#declare_attribute" do
  let(:declaration_1)              { stub("declaration", :name => "declaration 1") }
  let(:declaration_2)              { stub("declaration", :name => "declaration 2") }
  let(:declaration_with_same_name) { stub("declaration", :name => "declaration 1") }

  context "when not overridable" do
    it "adds the declaration to the list" do
      subject.declare_attribute(declaration_1)
      subject.to_a.should == [declaration_1]

      subject.declare_attribute(declaration_2)
      subject.to_a.should == [declaration_1, declaration_2]
    end
  end

  context "when overridable" do
    before { subject.overridable }

    it "adds the declaration to the list" do
      subject.declare_attribute(declaration_1)
      subject.to_a.should == [declaration_1]

      subject.declare_attribute(declaration_2)
      subject.to_a.should == [declaration_1, declaration_2]
    end

    it "deletes declarations with the same name" do
      subject.declare_attribute(declaration_1)
      subject.to_a.should == [declaration_1]

      subject.declare_attribute(declaration_2)
      subject.to_a.should == [declaration_1, declaration_2]

      subject.declare_attribute(declaration_with_same_name)
      subject.to_a.should == [declaration_2, declaration_with_same_name]
    end
  end
end
