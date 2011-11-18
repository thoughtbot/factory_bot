require "spec_helper"

describe FactoryWoman::AttributeList, "#define_attribute" do
  let(:static_attribute)  { FactoryWoman::Attribute::Static.new(:full_name, "value", false) }
  let(:dynamic_attribute) { FactoryWoman::Attribute::Dynamic.new(:email, false, lambda {|u| "#{u.full_name}@example.com" }) }

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
    }.to raise_error(FactoryWoman::AttributeDefinitionError, "Attribute already defined: full_name")
  end
end

describe FactoryWoman::AttributeList, "#define_attribute with a named attribute list" do
  subject { FactoryWoman::AttributeList.new(:author) }

  let(:association_with_same_name)      { FactoryWoman::Attribute::Association.new(:author, :author, {}) }
  let(:association_with_different_name) { FactoryWoman::Attribute::Association.new(:author, :post, {}) }

  it "raises when the attribute is a self-referencing association" do
    expect { subject.define_attribute(association_with_same_name) }.to raise_error(FactoryWoman::AssociationDefinitionError, "Self-referencing association 'author' in 'author'")
  end

  it "does not raise when the attribute is not a self-referencing association" do
    expect { subject.define_attribute(association_with_different_name) }.to_not raise_error
  end
end

describe FactoryWoman::AttributeList, "#apply_attributes" do
  let(:full_name_attribute) { FactoryWoman::Attribute::Static.new(:full_name, "John Adams", false) }
  let(:city_attribute)      { FactoryWoman::Attribute::Static.new(:city, "Boston", false) }
  let(:email_attribute)     { FactoryWoman::Attribute::Dynamic.new(:email, false, lambda {|model| "#{model.full_name}@example.com" }) }
  let(:login_attribute)     { FactoryWoman::Attribute::Dynamic.new(:login, false, lambda {|model| "username-#{model.full_name}" }) }

  def list(*attributes)
    FactoryWoman::AttributeList.new.tap do |list|
      attributes.each { |attribute| list.define_attribute(attribute) }
    end
  end

  it "prepends applied attributes" do
    subject.define_attribute(full_name_attribute)
    subject.apply_attributes(list(city_attribute))
    subject.to_a.should == [city_attribute, full_name_attribute]
  end

  it "moves non-static attributes to the end of the list" do
    subject.define_attribute(full_name_attribute)
    subject.apply_attributes(list(city_attribute, email_attribute))
    subject.to_a.should == [city_attribute, full_name_attribute, email_attribute]
  end

  it "maintains order of non-static attributes" do
    subject.define_attribute(full_name_attribute)
    subject.define_attribute(login_attribute)
    subject.apply_attributes(list(city_attribute, email_attribute))
    subject.to_a.should == [city_attribute, full_name_attribute, email_attribute, login_attribute]
  end

  it "doesn't overwrite attributes that are already defined" do
    subject.define_attribute(full_name_attribute)
    attribute_with_same_name = FactoryWoman::Attribute::Static.new(:full_name, "Benjamin Franklin", false)

    subject.apply_attributes(list(attribute_with_same_name))
    subject.to_a.should == [full_name_attribute]
  end
end
