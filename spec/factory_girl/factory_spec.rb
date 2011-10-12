require 'spec_helper'

describe FactoryGirl::Factory do
  before do
    @name    = :user
    @class   = define_class('User')
    @factory = FactoryGirl::Factory.new(@name)
    FactoryGirl.register_factory(@factory)
  end

  it "has a factory name" do
    @factory.name.should == @name
  end

  it "responds to factory_name" do
    @factory.factory_name.should == @name
  end

  it "has a build class" do
    @factory.build_class.should == @class
  end

  it "has a default strategy" do
    @factory.default_strategy.should == :create
  end

  it "passes a custom creation block" do
    proxy = stub("proxy", :result => nil)
    FactoryGirl::Proxy::Build.stubs(:new => proxy)
    block = lambda {}
    factory = FactoryGirl::Factory.new(:object)
    factory.to_create(&block)

    factory.run(FactoryGirl::Proxy::Build, {})

    proxy.should have_received(:result).with(block)
  end

  it "returns associations" do
    factory = FactoryGirl::Factory.new(:post)
    FactoryGirl.register_factory(FactoryGirl::Factory.new(:admin))
    factory.declare_attribute(FactoryGirl::Declaration::Association.new(:author, {}))
    factory.declare_attribute(FactoryGirl::Declaration::Association.new(:editor, {}))
    factory.declare_attribute(FactoryGirl::Declaration::Implicit.new(:admin, factory))
    factory.associations.each do |association|
      association.should be_association
    end
    factory.associations.size.should == 3
  end

  it "raises for a self referencing association" do
    factory = FactoryGirl::Factory.new(:post)
    lambda {
      factory.declare_attribute(FactoryGirl::Declaration::Association.new(:parent, { :factory => :post }))
      factory.ensure_compiled
    }.should raise_error(FactoryGirl::AssociationDefinitionError)
  end

  describe "when overriding generated attributes with a hash" do
    before do
      @name  = :name
      @value = 'The price is right!'
      @hash  = { @name => @value }
    end

    it "returns the overridden value in the generated attributes" do
      declaration = FactoryGirl::Declaration::Static.new(@name, 'The price is wrong, Bob!')
      @factory.declare_attribute(declaration)
      result = @factory.run(FactoryGirl::Proxy::AttributesFor, @hash)
      result[@name].should == @value
    end

    it "does not call a lazy attribute block for an overridden attribute" do
      declaration = FactoryGirl::Declaration::Dynamic.new(@name, lambda { flunk })
      @factory.declare_attribute(declaration)
      result = @factory.run(FactoryGirl::Proxy::AttributesFor, @hash)
    end

    it "overrides a symbol parameter with a string parameter" do
      declaration = FactoryGirl::Declaration::Static.new(@name, 'The price is wrong, Bob!')
      @factory.declare_attribute(declaration)
      @hash = { @name.to_s => @value }
      result = @factory.run(FactoryGirl::Proxy::AttributesFor, @hash)
      result[@name].should == @value
    end
  end

  describe "overriding an attribute with an alias" do
    before do
      @factory.declare_attribute(FactoryGirl::Declaration::Static.new(:test, 'original'))
      Factory.alias(/(.*)_alias/, '\1')
      @result = @factory.run(FactoryGirl::Proxy::AttributesFor,
                             :test_alias => 'new')
    end

    it "uses the passed in value for the alias" do
      @result[:test_alias].should == 'new'
    end

    it "discards the predefined value for the attribute" do
      @result[:test].should be_nil
    end
  end

  it "guesses the build class from the factory name" do
    @factory.build_class.should == User
  end

  it "creates a new factory using the class of the parent" do
    child = FactoryGirl::Factory.new(:child, :parent => @factory.name)
    child.ensure_compiled
    child.build_class.should == @factory.build_class
  end

  it "creates a new factory while overriding the parent class" do
    child = FactoryGirl::Factory.new(:child, :class => String, :parent => @factory.name)
    child.ensure_compiled
    child.build_class.should == String
  end
end

describe FactoryGirl::Factory, "when defined with a custom class" do
  subject           { FactoryGirl::Factory.new(:author, :class => Float) }
  its(:build_class) { should == Float }
end

describe FactoryGirl::Factory, "when defined with a class instead of a name" do
  let(:factory_class) { ArgumentError }
  let(:name)          { :argument_error }

  subject { FactoryGirl::Factory.new(factory_class) }

  its(:name)        { should == name }
  its(:build_class) { should == factory_class }
end

describe FactoryGirl::Factory, "when defined with a custom class name" do
  subject           { FactoryGirl::Factory.new(:author, :class => :argument_error) }
  its(:build_class) { should == ArgumentError }
end

describe FactoryGirl::Factory, "with a name ending in s" do
  let(:name)           { :business }
  let(:business_class) { Business }

  before  { define_class('Business') }
  subject { FactoryGirl::Factory.new(name) }

  its(:name)        { should == name }
  its(:build_class) { should == business_class }
end

describe FactoryGirl::Factory, "with a string for a name" do
  let(:name) { :string }
  subject    { FactoryGirl::Factory.new(name.to_s) }
  its(:name) { should == name }
end

describe FactoryGirl::Factory, "for namespaced class" do
  let(:name)           { :settings }
  let(:settings_class) { Admin::Settings }

  before do
    define_class("Admin")
    define_class("Admin::Settings")
  end

  context "with a namespaced class with Namespace::Class syntax" do
    subject { FactoryGirl::Factory.new(name, :class => "Admin::Settings") }

    it "sets build_class correctly" do
      subject.build_class.should == settings_class
    end
  end

  context "with a namespaced class with namespace/class syntax" do
    subject { FactoryGirl::Factory.new(name, :class => "admin/settings") }

    it "sets build_class correctly" do
      subject.build_class.should == settings_class
    end
  end
end

describe FactoryGirl::Factory do
  let(:factory_with_non_existent_strategy) do
    FactoryGirl::Factory.new(:object, :default_strategy => :nonexistent) { }
  end

  let(:factory_with_stub_strategy) do
    FactoryGirl::Factory.new(:object, :default_strategy => :stub)
  end

  before do
    define_class("User")
    define_class("Admin", User)
    FactoryGirl.register_factory(factory_with_stub_strategy)
  end

  it "raises an ArgumentError when trying to use a non-existent strategy" do
    expect { factory_with_non_existent_strategy }.to raise_error(ArgumentError)
  end

  it "creates a new factory with a specified default strategy" do
    factory_with_stub_strategy.default_strategy.should == :stub
  end

  describe "defining a child factory without setting default strategy" do
    subject { FactoryGirl::Factory.new(:other_object, :parent => factory_with_stub_strategy.name) }
    before  { subject.ensure_compiled }

    it "inherits default strategy from its parent" do
      subject.default_strategy.should == :stub
    end
  end

  describe "defining a child factory with a default strategy" do
    subject { FactoryGirl::Factory.new(:other_object, :default_strategy => :build, :parent => factory_with_stub_strategy.name) }
    before  { subject.ensure_compiled }

    it "overrides the default strategy from parent" do
      subject.default_strategy.should == :build
    end
  end
end

describe FactoryGirl::Factory, "human names" do
  context "factory name without underscores" do
    subject           { FactoryGirl::Factory.new(:user) }
    its(:names)       { should == [:user] }
    its(:human_names) { should == ["user"] }
  end

  context "factory name with underscores" do
    subject           { FactoryGirl::Factory.new(:happy_user) }
    its(:names)       { should == [:happy_user] }
    its(:human_names) { should == ["happy user"] }
  end

  context "factory name with aliases" do
    subject           { FactoryGirl::Factory.new(:happy_user, :aliases => [:gleeful_user, :person]) }
    its(:names)       { should == [:happy_user, :gleeful_user, :person] }
    its(:human_names) { should == ["happy user", "gleeful user", "person"] }
  end
end

describe FactoryGirl::Factory, "running a factory" do
  subject              { FactoryGirl::Factory.new(:user) }
  let(:attribute)      { FactoryGirl::Attribute::Static.new(:name, "value", false) }
  let(:declaration)    { FactoryGirl::Declaration::Static.new(:name, "value", false) }
  let(:proxy)          { stub("proxy", :result => "result", :set => nil) }
  let(:attributes)     { [attribute] }
  let(:attribute_list) { stub('attribute-list', :declarations => [declaration], :to_a => attributes) }

  before do
    define_model("User", :name => :string)
    FactoryGirl::Declaration::Static.stubs(:new => declaration)
    declaration.stubs(:to_attributes => attributes)
    attribute.stubs(:add_to => nil)
    FactoryGirl::Proxy::Build.stubs(:new => proxy)
    subject.declare_attribute(declaration)
  end

  it "creates the right proxy using the build class when running" do
    subject.run(FactoryGirl::Proxy::Build, {})
    FactoryGirl::Proxy::Build.should have_received(:new).with(subject.build_class)
  end

  it "adds the attribute to the proxy when running" do
    subject.run(FactoryGirl::Proxy::Build, {})
    attribute.should have_received(:add_to).with(proxy)
  end

  it "returns the result from the proxy when running" do
    subject.run(FactoryGirl::Proxy::Build, {}).should == "result"
    proxy.should have_received(:result).with(nil)
  end

  it "sets overrides once on the factory" do
    subject.run(FactoryGirl::Proxy::Build, { :name => "John Doe" })
    proxy.should have_received(:set).once
  end
end
