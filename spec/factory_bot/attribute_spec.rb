describe FactoryBot::Attribute do
  it "converts the name attribute to a symbol" do
    name = "user"
    attribute = FactoryBot::Attribute.new(name, false)

    expect(attribute.name).to eq name.to_sym
  end

  it "is not an association" do
    name = "user"
    attribute = FactoryBot::Attribute.new(name, false)

    expect(attribute).not_to be_association
  end
end
