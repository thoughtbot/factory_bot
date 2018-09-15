describe FactoryBot::Factory do
  before do
    @name    = :user
    @class   = define_class('User')
    @factory = FactoryBot::Factory.new(@name)
    FactoryBot.register_factory(@factory)
  end

  it "has a factory name" do
    expect(@factory.name).to eq @name
  end

  it "has a build class" do
    expect(@factory.build_class).to eq @class
  end

  it "passes a custom creation block" do
    strategy = double("strategy", result: nil, add_observer: true)
    allow(FactoryBot::Strategy::Build).to receive(:new).and_return strategy
    block = -> {}
    factory = FactoryBot::Factory.new(:object)
    factory.to_create(&block)

    factory.run(FactoryBot::Strategy::Build, {})

    expect(strategy).to have_received(:result).with(instance_of(FactoryBot::Evaluation))
  end

  it "returns associations" do
    factory = FactoryBot::Factory.new(:post)
    FactoryBot.register_factory(FactoryBot::Factory.new(:admin))
    factory.declare_attribute(FactoryBot::Declaration::Association.new(:author, {}))
    factory.declare_attribute(FactoryBot::Declaration::Association.new(:editor, {}))
    factory.declare_attribute(FactoryBot::Declaration::Implicit.new(:admin, factory))
    factory.associations.each do |association|
      expect(association).to be_association
    end
    expect(factory.associations.to_a.length).to eq 3
  end

  it "includes associations from the parent factory" do
    association_on_parent = FactoryBot::Declaration::Association.new(:association_on_parent, {})
    association_on_child  = FactoryBot::Declaration::Association.new(:association_on_child, {})

    factory = FactoryBot::Factory.new(:post)
    factory.declare_attribute(association_on_parent)
    FactoryBot.register_factory(factory)

    child_factory = FactoryBot::Factory.new(:child_post, parent: :post)
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
      declaration =
        FactoryBot::Declaration::Dynamic.new(@name, false, -> { flunk })
      @factory.declare_attribute(declaration)
      result = @factory.run(FactoryBot::Strategy::AttributesFor, @hash)
      expect(result[@name]).to eq @value
    end

    it "overrides a symbol parameter with a string parameter" do
      declaration =
        FactoryBot::Declaration::Dynamic.new(@name, false, -> { flunk })
      @factory.declare_attribute(declaration)
      @hash = { @name.to_s => @value }
      result = @factory.run(FactoryBot::Strategy::AttributesFor, @hash)
      expect(result[@name]).to eq @value
    end
  end

  describe "overriding an attribute with an alias" do
    before do
      attribute = FactoryBot::Declaration::Dynamic.new(
        :test,
        false, -> { "original" }
      )
      @factory.declare_attribute(attribute)
      FactoryBot.aliases << [/(.*)_alias/, '\1']
      @result = @factory.run(
        FactoryBot::Strategy::AttributesFor,
        test_alias: "new",
      )
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
    child = FactoryBot::Factory.new(:child, parent: @factory.name)
    child.compile
    expect(child.build_class).to eq @factory.build_class
  end

  it "creates a new factory while overriding the parent class" do
    child = FactoryBot::Factory.new(:child, class: String, parent: @factory.name)
    child.compile
    expect(child.build_class).to eq String
  end
end

describe FactoryBot::Factory, "when defined with a custom class" do
  subject           { FactoryBot::Factory.new(:author, class: Float) }
  its(:build_class) { should eq Float }
end

describe FactoryBot::Factory, "when given a class that overrides #to_s" do
  let(:overriding_class) { Overriding::Class }

  before do
    define_class("Overriding")
    define_class("Overriding::Class") do
      def self.to_s
        "Overriding"
      end
    end
  end

  subject { FactoryBot::Factory.new(:overriding_class, class: Overriding::Class) }

  it "sets build_class correctly" do
    expect(subject.build_class).to eq overriding_class
  end
end

describe FactoryBot::Factory, "when defined with a class instead of a name" do
  let(:factory_class) { ArgumentError }
  let(:name)          { :argument_error }

  subject { FactoryBot::Factory.new(factory_class) }

  its(:name)        { should eq name }
  its(:build_class) { should eq factory_class }
end

describe FactoryBot::Factory, "when defined with a custom class name" do
  subject           { FactoryBot::Factory.new(:author, class: :argument_error) }
  its(:build_class) { should eq ArgumentError }
end

describe FactoryBot::Factory, "with a name ending in s" do
  let(:name)           { :business }
  let(:business_class) { Business }

  before  { define_class('Business') }
  subject { FactoryBot::Factory.new(name) }

  its(:name)        { should eq name }
  its(:build_class) { should eq business_class }
end

describe FactoryBot::Factory, "with a string for a name" do
  let(:name) { :string }
  subject    { FactoryBot::Factory.new(name.to_s) }
  its(:name) { should eq name }
end

describe FactoryBot::Factory, "for namespaced class" do
  let(:name)           { :settings }
  let(:settings_class) { Admin::Settings }

  before do
    define_class("Admin")
    define_class("Admin::Settings")
  end

  context "with a namespaced class with Namespace::Class syntax" do
    subject { FactoryBot::Factory.new(name, class: "Admin::Settings") }

    it "sets build_class correctly" do
      expect(subject.build_class).to eq settings_class
    end
  end

  context "with a namespaced class with namespace/class syntax" do
    subject { FactoryBot::Factory.new(name, class: "admin/settings") }

    it "sets build_class correctly" do
      expect(subject.build_class).to eq settings_class
    end
  end
end

describe FactoryBot::Factory, "human names" do
  context "factory name without underscores" do
    subject           { FactoryBot::Factory.new(:user) }
    its(:names)       { should eq [:user] }
    its(:human_names) { should eq ["user"] }
  end

  context "factory name with underscores" do
    subject           { FactoryBot::Factory.new(:happy_user) }
    its(:names)       { should eq [:happy_user] }
    its(:human_names) { should eq ["happy user"] }
  end

  context "factory name with big letters" do
    subject           { FactoryBot::Factory.new(:LoL) }
    its(:names)       { should eq [:LoL] }
    its(:human_names) { should eq ["lol"] }
  end

  context "factory name with aliases" do
    subject           { FactoryBot::Factory.new(:happy_user, aliases: [:gleeful_user, :person]) }
    its(:names)       { should eq [:happy_user, :gleeful_user, :person] }
    its(:human_names) { should eq ["happy user", "gleeful user", "person"] }
  end
end

describe FactoryBot::Factory, "running a factory" do
  subject { FactoryBot::Factory.new(:user) }
  let(:attribute) do
    FactoryBot::Attribute::Dynamic.new(:name, false, -> { "value" })
  end
  let(:declaration) do
    FactoryBot::Declaration::Dynamic.new(:name, false, -> { "value" })
  end
  let(:strategy) { double("strategy", result: "result", add_observer: true) }
  let(:attributes) { [attribute] }
  let(:attribute_list) do
    double("attribute-list", declarations: [declaration], to_a: attributes)
  end

  before do
    define_model("User", name: :string)
    allow(FactoryBot::Declaration::Dynamic).to receive(:new).
      and_return declaration
    allow(declaration).to receive(:to_attributes).and_return attributes
    allow(FactoryBot::Strategy::Build).to receive(:new).and_return strategy
    subject.declare_attribute(declaration)
  end

  it "creates the right strategy using the build class when running" do
    subject.run(FactoryBot::Strategy::Build, {})
    expect(FactoryBot::Strategy::Build).to have_received(:new).once
  end

  it "returns the result from the strategy when running" do
    expect(subject.run(FactoryBot::Strategy::Build, {})).to eq "result"
  end

  it "calls the block and returns the result" do
    block_run = nil
    block = ->(result) { block_run = "changed" }
    subject.run(FactoryBot::Strategy::Build, {}, &block)
    expect(block_run).to eq "changed"
  end
end
