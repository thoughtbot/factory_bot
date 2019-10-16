describe FactoryBot::AttributeList, "#define_attribute" do
  it "maintains a list of attributes" do
    attribute = double(:attribute, name: :attribute_name)
    another_attribute = double(:attribute, name: :another_attribute_name)
    list = FactoryBot::AttributeList.new

    list.define_attribute(attribute)
    expect(list.to_a).to eq [attribute]

    list.define_attribute(another_attribute)
    expect(list.to_a).to eq [attribute, another_attribute]
  end

  it "returns the attribute" do
    attribute = double(:attribute, name: :attribute_name)
    list = FactoryBot::AttributeList.new

    expect(list.define_attribute(attribute)).to eq attribute
  end

  it "raises if an attribute has already been defined" do
    attribute = double(:attribute, name: :attribute_name)
    list = FactoryBot::AttributeList.new

    expect do
      2.times { list.define_attribute(attribute) }
    end.to raise_error(
      FactoryBot::AttributeDefinitionError,
      "Attribute already defined: attribute_name",
    )
  end
end

describe FactoryBot::AttributeList, "#define_attribute with a named attribute list" do
  it "raises when the attribute is a self-referencing association" do
    association_with_same_name = FactoryBot::Attribute::Association.new(:author, :author, {})
    list = FactoryBot::AttributeList.new(:author)

    expect do
      list.define_attribute(association_with_same_name)
    end.to raise_error(
      FactoryBot::AssociationDefinitionError,
      "Self-referencing association 'author' in 'author'",
    )
  end

  it "does not raise when the attribute is not a self-referencing association" do
    association_with_different_name = FactoryBot::Attribute::Association.new(:author, :post, {})
    list = FactoryBot::AttributeList.new

    expect { list.define_attribute(association_with_different_name) }.to_not raise_error
  end
end

describe FactoryBot::AttributeList, "#apply_attributes" do
  def list(*attributes)
    FactoryBot::AttributeList.new.tap do |list|
      attributes.each { |attribute| list.define_attribute(attribute) }
    end
  end

  it "adds attributes in the order defined" do
    attribute1 = double(:attribute1, name: :attribute1)
    attribute2 = double(:attribute2, name: :attribute2)
    attribute3 = double(:attribute3, name: :attribute3)
    list = FactoryBot::AttributeList.new

    list.define_attribute(attribute1)
    list.apply_attributes(list(attribute2, attribute3))
    expect(list.to_a).to eq [attribute1, attribute2, attribute3]
  end
end

describe FactoryBot::AttributeList, "#associations" do
  it "returns associations" do
    email_attribute = FactoryBot::Attribute::Dynamic.new(
      :email,
      false,
      ->(u) { "#{u.full_name}@example.com" },
    )
    author_attribute = FactoryBot::Attribute::Association.new(:author, :user, {})
    profile_attribute = FactoryBot::Attribute::Association.new(:profile, :profile, {})
    list = FactoryBot::AttributeList.new

    list.define_attribute(email_attribute)
    list.define_attribute(author_attribute)
    list.define_attribute(profile_attribute)

    expect(list.associations.to_a).to eq [author_attribute, profile_attribute]
  end
end

describe FactoryBot::AttributeList, "filter based on ignored attributes" do
  def build_ignored_attribute(name)
    FactoryBot::Attribute::Dynamic.new(name, true, -> { "value" })
  end

  def build_non_ignored_attribute(name)
    FactoryBot::Attribute::Dynamic.new(name, false, -> { "value" })
  end

  it "filters #ignored attributes" do
    list = FactoryBot::AttributeList.new
    list.define_attribute(build_ignored_attribute(:comments_count))
    list.define_attribute(build_ignored_attribute(:posts_count))
    list.define_attribute(build_non_ignored_attribute(:email))
    list.define_attribute(build_non_ignored_attribute(:first_name))
    list.define_attribute(build_non_ignored_attribute(:last_name))

    expect(list.ignored.names).to eq [:comments_count, :posts_count]
  end

  it "filters #non_ignored attributes" do
    list = FactoryBot::AttributeList.new
    list.define_attribute(build_ignored_attribute(:comments_count))
    list.define_attribute(build_ignored_attribute(:posts_count))
    list.define_attribute(build_non_ignored_attribute(:email))
    list.define_attribute(build_non_ignored_attribute(:first_name))
    list.define_attribute(build_non_ignored_attribute(:last_name))

    expect(list.non_ignored.names).to eq [:email, :first_name, :last_name]
  end
end

describe FactoryBot::AttributeList, "generating names" do
  def build_ignored_attribute(name)
    FactoryBot::Attribute::Dynamic.new(name, true, -> { "value" })
  end

  def build_non_ignored_attribute(name)
    FactoryBot::Attribute::Dynamic.new(name, false, -> { "value" })
  end

  def build_association(name)
    FactoryBot::Attribute::Association.new(name, :user, {})
  end

  it "knows all its #names" do
    list = FactoryBot::AttributeList.new
    list.define_attribute(build_ignored_attribute(:comments_count))
    list.define_attribute(build_ignored_attribute(:posts_count))
    list.define_attribute(build_non_ignored_attribute(:email))
    list.define_attribute(build_non_ignored_attribute(:first_name))
    list.define_attribute(build_non_ignored_attribute(:last_name))
    list.define_attribute(build_association(:avatar))

    expect(list.names).to eq [:comments_count, :posts_count, :email, :first_name, :last_name, :avatar]
  end

  it "knows all its #names for #ignored attributes" do
    list = FactoryBot::AttributeList.new
    list.define_attribute(build_ignored_attribute(:comments_count))
    list.define_attribute(build_ignored_attribute(:posts_count))
    list.define_attribute(build_non_ignored_attribute(:email))
    list.define_attribute(build_non_ignored_attribute(:first_name))
    list.define_attribute(build_non_ignored_attribute(:last_name))
    list.define_attribute(build_association(:avatar))

    expect(list.ignored.names).to eq [:comments_count, :posts_count]
  end

  it "knows all its #names for #non_ignored attributes" do
    list = FactoryBot::AttributeList.new
    list.define_attribute(build_ignored_attribute(:comments_count))
    list.define_attribute(build_ignored_attribute(:posts_count))
    list.define_attribute(build_non_ignored_attribute(:email))
    list.define_attribute(build_non_ignored_attribute(:first_name))
    list.define_attribute(build_non_ignored_attribute(:last_name))
    list.define_attribute(build_association(:avatar))

    expect(list.non_ignored.names).to eq [:email, :first_name, :last_name, :avatar]
  end

  it "knows all its #names for #associations" do
    list = FactoryBot::AttributeList.new
    list.define_attribute(build_ignored_attribute(:comments_count))
    list.define_attribute(build_ignored_attribute(:posts_count))
    list.define_attribute(build_non_ignored_attribute(:email))
    list.define_attribute(build_non_ignored_attribute(:first_name))
    list.define_attribute(build_non_ignored_attribute(:last_name))
    list.define_attribute(build_association(:avatar))

    expect(list.associations.names).to eq [:avatar]
  end
end
