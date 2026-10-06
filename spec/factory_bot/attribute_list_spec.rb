describe FactoryBot::AttributeList do
  def build_list
    FactoryBot::AttributeList.new([
      FactoryBot::Attribute::Dynamic.new(:email, false, -> {}),
      FactoryBot::Attribute::Association.new(:author, :user, {}),
      FactoryBot::Attribute::Dynamic.new(:admin, true, -> {})
    ])
  end

  it "enumerates the attributes in order" do
    expect(build_list.map(&:name)).to eq [:email, :author, :admin]
  end

  it "returns the attribute names" do
    expect(build_list.names).to eq [:email, :author, :admin]
  end

  it "returns the associations as a list" do
    associations = build_list.associations

    expect(associations).to be_a described_class
    expect(associations.names).to eq [:author]
  end

  it "returns the transient attributes as a list" do
    expect(build_list.transient.names).to eq [:admin]
  end

  it "returns the non-transient attributes as a list" do
    expect(build_list.non_transient.names).to eq [:email, :author]
  end
end
