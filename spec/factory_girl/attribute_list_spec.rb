require "spec_helper"

describe FactoryGirl::AttributeList, "#define_attribute" do
  let(:static_attribute)  { FactoryGirl::Attribute::Static.new(:full_name, "value", false) }
  let(:dynamic_attribute) { FactoryGirl::Attribute::Dynamic.new(:email, false, lambda {|u| "#{u.full_name}@example.com" }) }

  it "maintains a list of attributes" do
    subject.define_attribute(static_attribute)
    subject.to_a.should == [static_attribute]

    subject.define_attribute(dynamic_attribute)
    subject.to_a.should == [static_attribute, dynamic_attribute]
  end

  it "returns the attribute" do
    subject.define_attribute(static_attribute).should == static_attribute
    subject.define_attribute(dynamic_attribute).should == dynamic_attribute
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
  let(:email_attribute)     { FactoryGirl::Attribute::Dynamic.new(:email, false, lambda {|model| "#{model.full_name}@example.com" }) }
  let(:login_attribute)     { FactoryGirl::Attribute::Dynamic.new(:login, false, lambda {|model| "username-#{model.full_name}" }) }

  def list(*attributes)
    FactoryGirl::AttributeList.new.tap do |list|
      attributes.each { |attribute| list.define_attribute(attribute) }
    end
  end

  it "adds attributes in the order defined regardless of attribute type" do
    subject.define_attribute(full_name_attribute)
    subject.define_attribute(login_attribute)
    subject.apply_attributes(list(city_attribute, email_attribute))
    subject.to_a.should == [full_name_attribute, login_attribute, city_attribute, email_attribute]
  end
end

describe FactoryGirl::AttributeList, "#associations" do
  let(:full_name_attribute) { FactoryGirl::Attribute::Static.new(:full_name, "value", false) }
  let(:email_attribute)     { FactoryGirl::Attribute::Dynamic.new(:email, false, lambda {|u| "#{u.full_name}@example.com" }) }
  let(:author_attribute)    { FactoryGirl::Attribute::Association.new(:author, :user, {}) }
  let(:profile_attribute)   { FactoryGirl::Attribute::Association.new(:profile, :profile, {}) }

  before do
    subject.define_attribute(full_name_attribute)
    subject.define_attribute(email_attribute)
    subject.define_attribute(author_attribute)
    subject.define_attribute(profile_attribute)
  end

  it "returns associations" do
    subject.associations.should == [author_attribute, profile_attribute]
  end
end
