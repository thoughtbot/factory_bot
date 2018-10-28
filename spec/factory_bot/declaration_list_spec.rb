describe FactoryBot::DeclarationList, "#attributes" do
  let(:attribute_1) { double("attribute 1") }
  let(:attribute_2) { double("attribute 2") }
  let(:attribute_3) { double("attribute 3") }
  let(:declaration_1) do
    double(
      "declaration 1",
      to_attributes: [attribute_1, attribute_2],
    )
  end
  let(:declaration_2) do
    double("declaration_2", to_attributes: [attribute_3])
  end

  it "returns an AttributeList" do
    expect(subject.attributes).to be_a(FactoryBot::AttributeList)
  end

  let(:attribute_list) { double("attribute list", define_attribute: true) }

  it "defines each attribute on the attribute list" do
    allow(FactoryBot::AttributeList).to receive(:new).and_return attribute_list

    subject.declare_attribute(declaration_1)
    subject.declare_attribute(declaration_2)

    subject.attributes

    expect(attribute_list).to have_received(:define_attribute).with(attribute_1)
    expect(attribute_list).to have_received(:define_attribute).with(attribute_2)
    expect(attribute_list).to have_received(:define_attribute).with(attribute_3)
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
