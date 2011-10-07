require "spec_helper"

describe FactoryGirl::AttributeList, "overridable" do
  it { should_not be_overridable }

  it "can set itself as overridable" do
    subject.overridable
    subject.should be_overridable
  end
end

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

  context "when set as overridable" do
    let(:static_attribute_with_same_name) { FactoryGirl::Attribute::Static.new(:full_name, "overridden value", false) }
    before { subject.overridable }

    it "redefines the attribute if the name already exists" do
      subject.define_attribute(static_attribute)
      subject.define_attribute(static_attribute_with_same_name)

      subject.to_a.should == [static_attribute_with_same_name]
    end
  end
end

describe FactoryGirl::AttributeList, "#add_callback" do
  let(:proxy_class) { mock("klass") }
  let(:proxy) { FactoryGirl::Proxy.new(proxy_class) }

  it "allows for defining adding a callback" do
    subject.add_callback(FactoryGirl::Callback.new(:after_create, lambda { "Called after_create" }))

    subject.callbacks.first.name.should == :after_create
    subject.callbacks.first.run(nil, nil).should == "Called after_create"
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
    attribute_with_same_name = FactoryGirl::Attribute::Static.new(:full_name, "Benjamin Franklin", false)

    subject.apply_attributes(list(attribute_with_same_name))
    subject.to_a.should == [full_name_attribute]
  end

  context "when set as overridable" do
    before { subject.overridable }

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

    it "overwrites attributes that are already defined" do
      subject.define_attribute(full_name_attribute)
      attribute_with_same_name = FactoryGirl::Attribute::Static.new(:full_name, "Benjamin Franklin", false)

      subject.apply_attributes(list(attribute_with_same_name))
      subject.to_a.should == [attribute_with_same_name]
    end
  end
end
