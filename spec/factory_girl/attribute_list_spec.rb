require "spec_helper"

describe FactoryGirl::AttributeList, "#define_attribute" do
  let(:static_attribute)  { FactoryGirl::Attribute::Static.new(:full_name, "value", false) }
  let(:dynamic_attribute) { FactoryGirl::Attribute::Dynamic.new(:email, false, ->(u) { "#{u.full_name}@example.com" }) }

  it "maintains a list of attributes" do
    subject.define_attribute(static_attribute)
    expect(subject.to_a).to eq [static_attribute]

    subject.define_attribute(dynamic_attribute)
    expect(subject.to_a).to eq [static_attribute, dynamic_attribute]
  end

  it "returns the attribute" do
    expect(subject.define_attribute(static_attribute)).to eq static_attribute
    expect(subject.define_attribute(dynamic_attribute)).to eq dynamic_attribute
  end

  it "raises if an attribute has already been defined" do
    expect {
      2.times { subject.define_attribute(static_attribute) }
    }.to raise_error(FactoryGirl::AttributeDefinitionError, "Attribute already defined: full_name")
  end
end

describe FactoryGirl::AttributeList, "#define_attribute with a named attribute list" do
  subject { FactoryGirl::AttributeList.new(:author) }

  let(:association_with_same_name)      { FactoryGirl::Attribute::Association.new(:author, :author, {}) }
  let(:association_with_different_name) { FactoryGirl::Attribute::Association.new(:author, :post, {}) }

  it "raises when the attribute is a self-referencing association" do
    expect { subject.define_attribute(association_with_same_name) }.to raise_error(FactoryGirl::AssociationDefinitionError, "Self-referencing association 'author' in 'author'")
  end

  it "does not raise when the attribute is not a self-referencing association" do
    expect { subject.define_attribute(association_with_different_name) }.to_not raise_error
  end
end

describe FactoryGirl::AttributeList, "#apply_attributes" do
  let(:full_name_attribute) { FactoryGirl::Attribute::Static.new(:full_name, "John Adams", false) }
  let(:city_attribute)      { FactoryGirl::Attribute::Static.new(:city, "Boston", false) }
  let(:email_attribute)     { FactoryGirl::Attribute::Dynamic.new(:email, false, ->(model) { "#{model.full_name}@example.com" }) }
  let(:login_attribute)     { FactoryGirl::Attribute::Dynamic.new(:login, false, ->(model) { "username-#{model.full_name}" }) }

  def list(*attributes)
    FactoryGirl::AttributeList.new.tap do |list|
      attributes.each { |attribute| list.define_attribute(attribute) }
    end
  end

  it "adds attributes in the order defined regardless of attribute type" do
    subject.define_attribute(full_name_attribute)
    subject.define_attribute(login_attribute)
    subject.apply_attributes(list(city_attribute, email_attribute))
    expect(subject.to_a).to eq [full_name_attribute, login_attribute, city_attribute, email_attribute]
  end
end

describe FactoryGirl::AttributeList, "#associations" do
  let(:full_name_attribute) { FactoryGirl::Attribute::Static.new(:full_name, "value", false) }
  let(:email_attribute)     { FactoryGirl::Attribute::Dynamic.new(:email, false, ->(u) { "#{u.full_name}@example.com" }) }
  let(:author_attribute)    { FactoryGirl::Attribute::Association.new(:author, :user, {}) }
  let(:profile_attribute)   { FactoryGirl::Attribute::Association.new(:profile, :profile, {}) }

  before do
    subject.define_attribute(full_name_attribute)
    subject.define_attribute(email_attribute)
    subject.define_attribute(author_attribute)
    subject.define_attribute(profile_attribute)
  end

  it "returns associations" do
    expect(subject.associations.to_a).to eq [author_attribute, profile_attribute]
  end
end

describe FactoryGirl::AttributeList, "filter based on ignored attributes" do
  def build_ignored_attribute(name)
    FactoryGirl::Attribute::Static.new(name, "value", true)
  end

  def build_non_ignored_attribute(name)
    FactoryGirl::Attribute::Static.new(name, "value", false)
  end

  before do
    subject.define_attribute(build_ignored_attribute(:comments_count))
    subject.define_attribute(build_ignored_attribute(:posts_count))
    subject.define_attribute(build_non_ignored_attribute(:email))
    subject.define_attribute(build_non_ignored_attribute(:first_name))
    subject.define_attribute(build_non_ignored_attribute(:last_name))
  end

  it "filters #ignored attributes" do
    expect(subject.ignored.map(&:name)).to eq [:comments_count, :posts_count]
  end

  it "filters #non_ignored attributes" do
    expect(subject.non_ignored.map(&:name)).to eq [:email, :first_name, :last_name]
  end
end

describe FactoryGirl::AttributeList, "generating names" do
  def build_ignored_attribute(name)
    FactoryGirl::Attribute::Static.new(name, "value", true)
  end

  def build_non_ignored_attribute(name)
    FactoryGirl::Attribute::Static.new(name, "value", false)
  end

  def build_association(name)
    FactoryGirl::Attribute::Association.new(name, :user, {})
  end

  before do
    subject.define_attribute(build_ignored_attribute(:comments_count))
    subject.define_attribute(build_ignored_attribute(:posts_count))
    subject.define_attribute(build_non_ignored_attribute(:email))
    subject.define_attribute(build_non_ignored_attribute(:first_name))
    subject.define_attribute(build_non_ignored_attribute(:last_name))
    subject.define_attribute(build_association(:avatar))
  end

  it "knows all its #names" do
    expect(subject.names).to eq [:comments_count, :posts_count, :email, :first_name, :last_name, :avatar]
  end

  it "knows all its #names for #ignored attributes" do
    expect(subject.ignored.names).to eq [:comments_count, :posts_count]
  end

  it "knows all its #names for #non_ignored attributes" do
    expect(subject.non_ignored.names).to eq [:email, :first_name, :last_name, :avatar]
  end

  it "knows all its #names for #associations" do
    expect(subject.associations.names).to eq [:avatar]
  end
end
