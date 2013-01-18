require 'spec_helper'

describe FactoryGirl::Factory do
  before do
    @name    = :user
    @class   = define_class('User')
    @factory = FactoryGirl::Factory.new(@name)
    FactoryGirl.register_factory(@factory)
  end

  it "has a factory name" do
    expect(@factory.name).to eq @name
  end

  it "has a build class" do
    expect(@factory.build_class).to eq @class
  end

  it "passes a custom creation block" do
    strategy = stub("strategy", result: nil, add_observer: true)
    FactoryGirl::Strategy::Build.stubs(new: strategy)
    block = -> {}
    factory = FactoryGirl::Factory.new(:object)
    factory.to_create(&block)

    factory.run(FactoryGirl::Strategy::Build, {})

    expect(strategy).to have_received(:result).with(instance_of(FactoryGirl::Evaluation))
  end

  it "returns associations" do
    factory = FactoryGirl::Factory.new(:post)
    FactoryGirl.register_factory(FactoryGirl::Factory.new(:admin))
    factory.declare_attribute(FactoryGirl::Declaration::Association.new(:author, {}))
    factory.declare_attribute(FactoryGirl::Declaration::Association.new(:editor, {}))
    factory.declare_attribute(FactoryGirl::Declaration::Implicit.new(:admin, factory))
    factory.associations.each do |association|
      expect(association).to be_association
    end
    expect(factory.associations.to_a.length).to eq 3
  end

  it "includes associations from the parent factory" do
    association_on_parent = FactoryGirl::Declaration::Association.new(:association_on_parent, {})
    association_on_child  = FactoryGirl::Declaration::Association.new(:association_on_child, {})

    factory = FactoryGirl::Factory.new(:post)
    factory.declare_attribute(association_on_parent)
    FactoryGirl.register_factory(factory)

    child_factory = FactoryGirl::Factory.new(:child_post, parent: :post)
    child_factory.declare_attribute(association_on_child)

    expect(child_factory.associations.map(&:name)).to eq [:association_on_parent, :association_on_child]
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
      expect(result[@name]).to eq @value
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
      expect(result[@name]).to eq @value
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
      expect(@result[:test_alias]).to eq 'new'
    end

    it "discards the predefined value for the attribute" do
      expect(@result[:test]).to be_nil
    end
  end

  it "guesses the build class from the factory name" do
    expect(@factory.build_class).to eq User
  end

  it "creates a new factory using the class of the parent" do
    child = FactoryGirl::Factory.new(:child, parent: @factory.name)
    child.compile
    expect(child.build_class).to eq @factory.build_class
  end

  it "creates a new factory while overriding the parent class" do
    child = FactoryGirl::Factory.new(:child, class: String, parent: @factory.name)
    child.compile
    expect(child.build_class).to eq String
  end
end

describe FactoryGirl::Factory, "when defined with a custom class" do
  subject           { FactoryGirl::Factory.new(:author, class: Float) }
  its(:build_class) { should eq Float }
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
    expect(subject.build_class).to eq overriding_class
  end
end

describe FactoryGirl::Factory, "when defined with a class instead of a name" do
  let(:factory_class) { ArgumentError }
  let(:name)          { :argument_error }

  subject { FactoryGirl::Factory.new(factory_class) }

  its(:name)        { should eq name }
  its(:build_class) { should eq factory_class }
end

describe FactoryGirl::Factory, "when defined with a custom class name" do
  subject           { FactoryGirl::Factory.new(:author, class: :argument_error) }
  its(:build_class) { should eq ArgumentError }
end

describe FactoryGirl::Factory, "with a name ending in s" do
  let(:name)           { :business }
  let(:business_class) { Business }

  before  { define_class('Business') }
  subject { FactoryGirl::Factory.new(name) }

  its(:name)        { should eq name }
  its(:build_class) { should eq business_class }
end

describe FactoryGirl::Factory, "with a string for a name" do
  let(:name) { :string }
  subject    { FactoryGirl::Factory.new(name.to_s) }
  its(:name) { should eq name }
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
      expect(subject.build_class).to eq settings_class
    end
  end

  context "with a namespaced class with namespace/class syntax" do
    subject { FactoryGirl::Factory.new(name, class: "admin/settings") }

    it "sets build_class correctly" do
      expect(subject.build_class).to eq settings_class
    end
  end
end

describe FactoryGirl::Factory, "human names" do
  context "factory name without underscores" do
    subject           { FactoryGirl::Factory.new(:user) }
    its(:names)       { should eq [:user] }
    its(:human_names) { should eq ["user"] }
  end

  context "factory name with underscores" do
    subject           { FactoryGirl::Factory.new(:happy_user) }
    its(:names)       { should eq [:happy_user] }
    its(:human_names) { should eq ["happy user"] }
  end

  context "factory name with big letters" do
    subject           { FactoryGirl::Factory.new(:LoL) }
    its(:names)       { should eq [:LoL] }
    its(:human_names) { should eq ["lol"] }
  end

  context "factory name with aliases" do
    subject           { FactoryGirl::Factory.new(:happy_user, aliases: [:gleeful_user, :person]) }
    its(:names)       { should eq [:happy_user, :gleeful_user, :person] }
    its(:human_names) { should eq ["happy user", "gleeful user", "person"] }
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
    expect(FactoryGirl::Strategy::Build).to have_received(:new).once
  end

  it "returns the result from the strategy when running" do
    expect(subject.run(FactoryGirl::Strategy::Build, {})).to eq "result"
  end

  it "calls the block and returns the result" do
    block_run = nil
    block = ->(result) { block_run = "changed" }
    subject.run(FactoryGirl::Strategy::Build, { }, &block)
    expect(block_run).to eq "changed"
  end
end
