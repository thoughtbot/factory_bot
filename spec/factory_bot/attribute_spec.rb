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

  it "tracks whether the attribute is transient" do
    transient_attribute = FactoryBot::Attribute.new(:comments_count, true)
    persistent_attribute = FactoryBot::Attribute.new(:email, false)

    expect(transient_attribute.transient).to be true
    expect(persistent_attribute.transient).to be false
  end
end
