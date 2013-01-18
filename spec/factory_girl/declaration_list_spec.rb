require "spec_helper"

describe FactoryGirl::DeclarationList, "#attributes" do
  let(:static_attribute_1)  { stub("static attribute 1") }
  let(:static_attribute_2)  { stub("static attribute 2") }
  let(:dynamic_attribute_1) { stub("dynamic attribute 1") }
  let(:static_declaration)  { stub("static declaration", to_attributes: [static_attribute_1, static_attribute_2]) }
  let(:dynamic_declaration) { stub("static declaration", to_attributes: [dynamic_attribute_1]) }

  it "returns an AttributeList" do
    expect(subject.attributes).to be_a(FactoryGirl::AttributeList)
  end

  let(:attribute_list) { stub("attribute list", define_attribute: true) }

  it "defines each attribute on the attribute list" do
    FactoryGirl::AttributeList.stubs(new: attribute_list)

    subject.declare_attribute(static_declaration)
    subject.declare_attribute(dynamic_declaration)

    subject.attributes

    expect(attribute_list).to have_received(:define_attribute).with(static_attribute_1)
    expect(attribute_list).to have_received(:define_attribute).with(static_attribute_2)
    expect(attribute_list).to have_received(:define_attribute).with(dynamic_attribute_1)
  end
end

describe FactoryGirl::DeclarationList, "#declare_attribute" do
  let(:declaration_1)              { stub("declaration", name: "declaration 1") }
  let(:declaration_2)              { stub("declaration", name: "declaration 2") }
  let(:declaration_with_same_name) { stub("declaration", name: "declaration 1") }

  context "when not overridable" do
    it "adds the declaration to the list" do
      subject.declare_attribute(declaration_1)
      expect(subject.to_a).to eq [declaration_1]

      subject.declare_attribute(declaration_2)
      expect(subject.to_a).to eq [declaration_1, declaration_2]
    end
  end

  context "when overridable" do
    before { subject.overridable }

    it "adds the declaration to the list" do
      subject.declare_attribute(declaration_1)
      expect(subject.to_a).to eq [declaration_1]

      subject.declare_attribute(declaration_2)
      expect(subject.to_a).to eq [declaration_1, declaration_2]
    end

    it "deletes declarations with the same name" do
      subject.declare_attribute(declaration_1)
      expect(subject.to_a).to eq [declaration_1]

      subject.declare_attribute(declaration_2)
      expect(subject.to_a).to eq [declaration_1, declaration_2]

      subject.declare_attribute(declaration_with_same_name)
      expect(subject.to_a).to eq [declaration_2, declaration_with_same_name]
    end
  end
end
