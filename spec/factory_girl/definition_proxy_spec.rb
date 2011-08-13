require 'spec_helper'

describe FactoryGirl::DefinitionProxy do
  let(:factory) { FactoryGirl::Factory.new(:object) }
  subject { FactoryGirl::DefinitionProxy.new(factory) }

  it "should add a static attribute for type" do
    subject.type 'value'
    factory.attributes.last.should be_kind_of(FactoryGirl::Attribute::Static)
  end

  it "should add a static attribute for id" do
    subject.id 'value'
    factory.attributes.last.should be_kind_of(FactoryGirl::Attribute::Static)
  end

  it "should add a static attribute when an attribute is defined with a value" do
    attribute = stub('attribute', :name => :name)
    FactoryGirl::Attribute::Static.stubs(:new => attribute)
    factory.stubs(:define_attribute)
    subject.add_attribute(:name, 'value')
    factory.should have_received(:define_attribute).with(attribute)
    FactoryGirl::Attribute::Static.should have_received(:new).with(:name, "value")
  end

  it "should add a dynamic attribute when an attribute is defined with a block" do
    attribute = stub('attribute', :name => :name)
    block     = lambda {}
    FactoryGirl::Attribute::Dynamic.stubs(:new => attribute)
    factory.stubs(:define_attribute)
    subject.add_attribute(:name, &block)
    FactoryGirl::Attribute::Dynamic.should have_received(:new).with(:name, block)
    factory.should have_received(:define_attribute).with(attribute)
  end

  it "should raise for an attribute with a value and a block" do
    lambda {
      subject.add_attribute(:name, 'value') {}
    }.should raise_error(FactoryGirl::AttributeDefinitionError)
  end

  it "should add an attribute with a built-in private method" do
    subject.instance_eval { sleep(0.1) }
    factory.attributes.map { |attribute| attribute.name }.should == [:sleep]
  end

  describe "child factories" do
    its(:child_factories) { should == [] }

    it "should be able to add child factories" do
      block = lambda {}
      subject.factory(:admin, { :aliases => [:great] }, &block)
      subject.child_factories.should == [[:admin, { :aliases => [:great] }, block]]
    end
  end

  describe "adding an attribute using a in-line sequence" do
    it "should create the sequence" do
      FactoryGirl::Sequence.stubs(:new)
      subject.sequence(:name) {}
      FactoryGirl::Sequence.should have_received(:new).with(:name, 1)
    end

    it "should create the sequence with a custom default value" do
      FactoryGirl::Sequence.stubs(:new)
      subject.sequence(:name, "A") {}
      FactoryGirl::Sequence.should have_received(:new).with(:name, "A")
    end

    it "should add a dynamic attribute" do
      attribute = stub('attribute', :name => :name)
      FactoryGirl::Attribute::Dynamic.stubs(:new => attribute)
      subject.sequence(:name) {}
      factory.attributes.should include(attribute)
      FactoryGirl::Attribute::Dynamic.should have_received(:new).with(:name, is_a(Proc))
    end
  end

  it "should add a callback attribute when the after_build attribute is defined" do
    FactoryGirl::Attribute::Callback.stubs(:new => "after_build callback")
    subject.after_build {}
    factory.attributes.should include('after_build callback')
    FactoryGirl::Attribute::Callback.should have_received(:new).with(:after_build, is_a(Proc))
  end

  it "should add a callback attribute when the after_create attribute is defined" do
    FactoryGirl::Attribute::Callback.stubs(:new => "after_create callback")
    subject.after_create {}
    factory.attributes.should include('after_create callback')
    FactoryGirl::Attribute::Callback.should have_received(:new).with(:after_create, is_a(Proc))
  end

  it "should add a callback attribute when the after_stub attribute is defined" do
    FactoryGirl::Attribute::Callback.stubs(:new => "after_stub callback")
    subject.after_stub {}
    factory.attributes.should include('after_stub callback')
    FactoryGirl::Attribute::Callback.should have_received(:new).with(:after_stub, is_a(Proc))
  end

  it "should add an association without a factory name or overrides" do
    name = :user
    attr = stub('attribute', :name => name)
    FactoryGirl::Attribute::Association.stubs(:new => attr)
    subject.association(name)
    factory.attributes.should include(attr)
    FactoryGirl::Attribute::Association.should have_received(:new).with(name, name, {})
  end

  it "should add an association with overrides" do
    name      = :user
    attr      = stub('attribute', :name => name)
    overrides = { :first_name => 'Ben' }
    FactoryGirl::Attribute::Association.stubs(:new => attr)
    subject.association(name, overrides)
    factory.attributes.should include(attr)
    FactoryGirl::Attribute::Association.should have_received(:new).with(name, name, overrides)
  end

  it "should add an attribute using the method name when passed an undefined method" do
    attribute = stub('attribute', :name => :name)
    FactoryGirl::Attribute::Static.stubs(:new => attribute)
    subject.send(:name, 'value')
    factory.attributes.should include(attribute)
    FactoryGirl::Attribute::Static.should have_received(:new).with(:name, 'value')
  end

  it "adds an attribute using when passed an undefined method and block" do
    attribute = stub('attribute', :name => :name)
    block = lambda {}
    FactoryGirl::Attribute::Dynamic.stubs(:new => attribute)
    subject.send(:name, &block)
    factory.attributes.should include(attribute)
    FactoryGirl::Attribute::Dynamic.should have_received(:new).with(:name, block)
  end

  it "adds an implicit attribute when passed an undefined method without arguments or a block" do
    name = :user
    attr = stub('attribute', :name => name)
    FactoryGirl::Attribute::Implicit.stubs(:new => attr)
    subject.send(name)
    factory.attributes.should include(attr)
    FactoryGirl::Attribute::Implicit.should have_received(:new).with(name, factory)
  end

  it "adds an association when passed an undefined method with a hash including :factory key" do
    name = :author
    factory_name = :user
    overrides = { :first_name => 'Ben' }
    args = { :factory => factory_name }.merge(overrides)
    attr = stub('attribute', :name => name)
    FactoryGirl::Attribute::Association.stubs(:new => attr)
    subject.send(name, args)
    factory.attributes.should include(attr)
    FactoryGirl::Attribute::Association.should have_received(:new).with(name, factory_name, overrides)
  end

  it "delegates to_create" do
    result = 'expected'
    factory.stubs(:to_create => result)
    subject.to_create.should == result
    factory.should have_received(:to_create)
  end
end
