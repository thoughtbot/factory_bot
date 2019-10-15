describe FactoryBot::DeclarationList, "#attributes" do
  it "returns an AttributeList" do
    declaration_list = FactoryBot::DeclarationList.new

    expect(declaration_list.attributes).to be_a(FactoryBot::AttributeList)
  end

  it "defines each attribute on the attribute list" do
    attribute1 = double("attribute 1")
    attribute2 = double("attribute 2")
    attribute3 = double("attribute 3")
    declaration1 = double("declaration 1", to_attributes: [attribute1, attribute2])
    declaration2 = double("declaration2", to_attributes: [attribute3])
    attribute_list = double("attribute list", define_attribute: true)
    declaration_list = FactoryBot::DeclarationList.new

    allow(FactoryBot::AttributeList).to receive(:new).and_return attribute_list

    declaration_list.declare_attribute(declaration1)
    declaration_list.declare_attribute(declaration2)

    declaration_list.attributes

    expect(attribute_list).to have_received(:define_attribute).with(attribute1)
    expect(attribute_list).to have_received(:define_attribute).with(attribute2)
    expect(attribute_list).to have_received(:define_attribute).with(attribute3)
  end
end

describe FactoryBot::DeclarationList, "#declare_attribute" do
  it "adds the declaration to the list when not overridable" do
    declaration1 = double("declaration", name: "declaration 1")
    declaration2 = double("declaration", name: "declaration 2")
    declaration_list = FactoryBot::DeclarationList.new

    declaration_list.declare_attribute(declaration1)
    expect(declaration_list.to_a).to eq [declaration1]

    declaration_list.declare_attribute(declaration2)
    expect(declaration_list.to_a).to eq [declaration1, declaration2]
  end

  it "adds the declaration to the list when overridable" do
    declaration1 = double("declaration", name: "declaration 1")
    declaration2 = double("declaration", name: "declaration 2")
    declaration_list = FactoryBot::DeclarationList.new
    declaration_list.overridable

    declaration_list.declare_attribute(declaration1)
    expect(declaration_list.to_a).to eq [declaration1]

    declaration_list.declare_attribute(declaration2)
    expect(declaration_list.to_a).to eq [declaration1, declaration2]
  end

  it "deletes declarations with the same name when overridable" do
    declaration1 = double("declaration", name: "declaration 1")
    declaration2 = double("declaration", name: "declaration 2")
    declaration_with_same_name = double("declaration", name: "declaration 1")
    declaration_list = FactoryBot::DeclarationList.new
    declaration_list.overridable

    declaration_list.declare_attribute(declaration1)
    expect(declaration_list.to_a).to eq [declaration1]

    declaration_list.declare_attribute(declaration2)
    expect(declaration_list.to_a).to eq [declaration1, declaration2]

    declaration_list.declare_attribute(declaration_with_same_name)
    expect(declaration_list.to_a).to eq [declaration2, declaration_with_same_name]
  end

  it "appends declarations with the same name when NOT overridable" do
    declaration1 = double("declaration", name: "declaration 1")
    declaration2 = double("declaration", name: "declaration 2")
    declaration_with_same_name = double("declaration", name: "declaration 1")

    # DeclarationList's `@overridable` attr is set to false by default
    declaration_list = FactoryBot::DeclarationList.new

    declaration_list.declare_attribute(declaration1)
    expect(declaration_list.to_a).to eq [declaration1]

    declaration_list.declare_attribute(declaration2)
    expect(declaration_list.to_a).to eq [declaration1, declaration2]

    declaration_list.declare_attribute(declaration_with_same_name)
    expect(declaration_list.to_a).to eq [declaration1, declaration2, declaration_with_same_name]
  end
end
