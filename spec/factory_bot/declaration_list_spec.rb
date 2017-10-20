require "spec_helper"

describe FactoryBot::DeclarationList, "#attributes" do
  let(:static_attribute_1)  { double("static attribute 1") }
  let(:static_attribute_2)  { double("static attribute 2") }
  let(:dynamic_attribute_1) { double("dynamic attribute 1") }
  let(:static_declaration)  do
    double(
      "static declaration",
      to_attributes: [static_attribute_1, static_attribute_2],
    )
  end
  let(:dynamic_declaration) do
    double("static declaration", to_attributes: [dynamic_attribute_1])
  end

  it "returns an AttributeList" do
    expect(subject.attributes).to be_a(FactoryBot::AttributeList)
  end

  let(:attribute_list) { double("attribute list", define_attribute: true) }

  it "defines each attribute on the attribute list" do
    allow(FactoryBot::AttributeList).to receive(:new).and_return attribute_list

    subject.declare_attribute(static_declaration)
    subject.declare_attribute(dynamic_declaration)

    subject.attributes

    expect(attribute_list).to have_received(:define_attribute).with(static_attribute_1)
    expect(attribute_list).to have_received(:define_attribute).with(static_attribute_2)
    expect(attribute_list).to have_received(:define_attribute).with(dynamic_attribute_1)
  end
end

describe FactoryBot::DeclarationList, "#declare_attribute" do
  let(:declaration_1) { double("declaration", name: "declaration 1") }
  let(:declaration_2) { double("declaration", name: "declaration 2") }
  let(:declaration_with_same_name) do
    double("declaration", name: "declaration 1")
  end

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
