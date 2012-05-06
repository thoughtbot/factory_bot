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

  it "has a build class" do
    @factory.build_class.should == @class
  end

  it "passes a custom creation block" do
    strategy = stub("strategy", result: nil, add_observer: true)
    FactoryGirl::Strategy::Build.stubs(new: strategy)
    block = -> {}
    factory = FactoryGirl::Factory.new(:object)
    factory.to_create(&block)

    factory.run(FactoryGirl::Strategy::Build, {})

    strategy.should have_received(:result).with(instance_of(FactoryGirl::Evaluation))
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
    factory.associations.to_a.length.should == 3
  end

  it "includes associations from the parent factory" do
    association_on_parent = FactoryGirl::Declaration::Association.new(:association_on_parent, {})
    association_on_child  = FactoryGirl::Declaration::Association.new(:association_on_child, {})

    factory = FactoryGirl::Factory.new(:post)
    factory.declare_attribute(association_on_parent)
    FactoryGirl.register_factory(factory)

    child_factory = FactoryGirl::Factory.new(:child_post, parent: :post)
    child_factory.declare_attribute(association_on_child)

    child_factory.associations.map(&:name).should == [:association_on_parent, :association_on_child]
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
      result = @factory.run(FactoryGirl::Strategy::AttributesFor, @hash)
      result[@name].should == @value
    end

    it "does not call a lazy attribute block for an overridden attribute" do
      declaration = FactoryGirl::Declaration::Dynamic.new(@name, false, -> { flunk })
      @factory.declare_attribute(declaration)
      @factory.run(FactoryGirl::Strategy::AttributesFor, @hash)
    end

    it "overrides a symbol parameter with a string parameter" do
      declaration = FactoryGirl::Declaration::Static.new(@name, 'The price is wrong, Bob!')
      @factory.declare_attribute(declaration)
      @hash = { @name.to_s => @value }
      result = @factory.run(FactoryGirl::Strategy::AttributesFor, @hash)
      result[@name].should == @value
    end
  end

  describe "overriding an attribute with an alias" do
    before do
      @factory.declare_attribute(FactoryGirl::Declaration::Static.new(:test, 'original'))
      FactoryGirl.aliases << [/(.*)_alias/, '\1']
      @result = @factory.run(FactoryGirl::Strategy::AttributesFor,
                             test_alias: 'new')
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
    child = FactoryGirl::Factory.new(:child, parent: @factory.name)
    child.compile
    child.build_class.should == @factory.build_class
  end

  it "creates a new factory while overriding the parent class" do
    child = FactoryGirl::Factory.new(:child, class: String, parent: @factory.name)
    child.compile
    child.build_class.should == String
  end
end

describe FactoryGirl::Factory, "when defined with a custom class" do
  subject           { FactoryGirl::Factory.new(:author, class: Float) }
  its(:build_class) { should == Float }
end

describe FactoryGirl::Factory, "when given a class that overrides #to_s" do
  let(:overriding_class) { Overriding::Class }

  before do
    define_class("Overriding")
    define_class("Overriding::Class") do
      def self.to_s
        "Overriding"
      end
    end
  end

  subject { FactoryGirl::Factory.new(:overriding_class, class: Overriding::Class) }

  it "sets build_class correctly" do
    subject.build_class.should == overriding_class
  end
end

describe FactoryGirl::Factory, "when defined with a class instead of a name" do
  let(:factory_class) { ArgumentError }
  let(:name)          { :argument_error }

  subject { FactoryGirl::Factory.new(factory_class) }

  its(:name)        { should == name }
  its(:build_class) { should == factory_class }
end

describe FactoryGirl::Factory, "when defined with a custom class name" do
  subject           { FactoryGirl::Factory.new(:author, class: :argument_error) }
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
    subject { FactoryGirl::Factory.new(name, class: "Admin::Settings") }

    it "sets build_class correctly" do
      subject.build_class.should == settings_class
    end
  end

  context "with a namespaced class with namespace/class syntax" do
    subject { FactoryGirl::Factory.new(name, class: "admin/settings") }

    it "sets build_class correctly" do
      subject.build_class.should == settings_class
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

  context "factory name with big letters" do
    subject           { FactoryGirl::Factory.new(:LoL) }
    its(:names)       { should == [:LoL] }
    its(:human_names) { should == ["lol"] }
  end

  context "factory name with aliases" do
    subject           { FactoryGirl::Factory.new(:happy_user, aliases: [:gleeful_user, :person]) }
    its(:names)       { should == [:happy_user, :gleeful_user, :person] }
    its(:human_names) { should == ["happy user", "gleeful user", "person"] }
  end
end

describe FactoryGirl::Factory, "running a factory" do
  subject              { FactoryGirl::Factory.new(:user) }
  let(:attribute)      { FactoryGirl::Attribute::Static.new(:name, "value", false) }
  let(:declaration)    { FactoryGirl::Declaration::Static.new(:name, "value", false) }
  let(:strategy)       { stub("strategy", result: "result", add_observer: true) }
  let(:attributes)     { [attribute] }
  let(:attribute_list) { stub('attribute-list', declarations: [declaration], to_a: attributes) }

  before do
    define_model("User", name: :string)
    FactoryGirl::Declaration::Static.stubs(new: declaration)
    declaration.stubs(to_attributes: attributes)
    FactoryGirl::Strategy::Build.stubs(new: strategy)
    subject.declare_attribute(declaration)
  end

  it "creates the right strategy using the build class when running" do
    subject.run(FactoryGirl::Strategy::Build, {})
    FactoryGirl::Strategy::Build.should have_received(:new).once
  end

  it "returns the result from the strategy when running" do
    subject.run(FactoryGirl::Strategy::Build, {}).should == "result"
  end

  it "calls the block and returns the result" do
    block_run = nil
    block = ->(result) { block_run = "changed" }
    subject.run(FactoryGirl::Strategy::Build, { }, &block)
    block_run.should == "changed"
  end
end

describe FactoryGirl::Factory, "#with_traits" do
  subject            { FactoryGirl::Factory.new(:user) }
  let(:admin_trait)  { FactoryGirl::Trait.new(:admin) }
  let(:female_trait) { FactoryGirl::Trait.new(:female) }
  let(:admin_definition) { admin_trait.definition }
  let(:female_definition) { female_trait.definition }

  before do
    FactoryGirl.register_trait(admin_trait)
    FactoryGirl.register_trait(female_trait)
  end

  it "returns a factory with the correct definitions" do
    subject.with_traits([:admin, :female]).definition_list[1, 2].should == [admin_definition, female_definition]
  end

  it "doesn't modify the original factory's processing order" do
    subject.with_traits([:admin, :female])
    subject.definition_list.should == [subject.definition]
  end
end
