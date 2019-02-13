describe FactoryBot::DefinitionProxy, "#add_attribute" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  it "declares a dynamic attribute on the factory" do
    attribute_value = -> { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    expect(subject).to have_dynamic_declaration(:attribute_name).
      with_value(attribute_value)
  end
end

describe FactoryBot::DefinitionProxy, "#add_attribute when the proxy ignores attributes" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject, true) }

  it "declares a dynamic attribute on the factory" do
    attribute_value = -> { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    expect(subject).to have_dynamic_declaration(:attribute_name).
      ignored.
      with_value(attribute_value)
  end
end

describe FactoryBot::DefinitionProxy, "#transient" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  it "makes all attributes added ignored" do
    attribute_value = -> { "dynamic_attribute" }
    proxy.transient do
      add_attribute(:attribute_name, &attribute_value)
    end

    expect(subject).to have_dynamic_declaration(:attribute_name).
      ignored.
      with_value(attribute_value)
  end
end

describe FactoryBot::DefinitionProxy, "#method_missing" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  context "when called without args or a block" do
    it "declares an implicit declaration" do
      proxy.bogus
      expect(subject).to have_implicit_declaration(:bogus).with_factory(subject)
    end
  end

  context "when called with a ':factory' key" do
    it "declares an association" do
      proxy.author factory: :user
      expect(subject).to have_association_declaration(:author).
        with_options(factory: :user)
    end
  end

  context "when called with a block" do
    it "declares a dynamic attribute" do
      attribute_value = -> { "dynamic attribute" }
      proxy.attribute_name(&attribute_value)
      expect(subject).to have_dynamic_declaration(:attribute_name).
        with_value(attribute_value)
    end
  end

  context "when called with a static-attribute-like argument" do
    it "raises a NoMethodError" do
      definition = FactoryBot::Definition.new(:broken)
      proxy = FactoryBot::DefinitionProxy.new(definition)

      invalid_call = -> { proxy.static_attributes_are_gone true }
      expect(invalid_call).to raise_error(
        NoMethodError,
        "undefined method 'static_attributes_are_gone' in 'broken' factory",
      )
    end
  end

  context "when called with a setter method" do
    it "raises a NoMethodError" do
      definition = FactoryBot::Definition.new(:broken)
      proxy = FactoryBot::DefinitionProxy.new(definition)

      invalid_call = -> { proxy.setter_method = true }
      expect(invalid_call).to raise_error(
        NoMethodError,
        "undefined method 'setter_method=' in 'broken' factory",
      )
    end
  end
end

describe FactoryBot::DefinitionProxy, "#sequence" do
  before do
    allow(FactoryBot::Sequence).to receive(:new).and_call_original
  end

  def build_proxy(factory_name)
    definition = FactoryBot::Definition.new(factory_name)
    FactoryBot::DefinitionProxy.new(definition)
  end

  it "creates a new sequence starting at 1" do
    proxy = build_proxy(:factory)

    proxy.sequence(:sequence)

    expect(FactoryBot::Sequence).to have_received(:new).with(:sequence)
  end

  it "creates a new sequence with an overridden starting vaue" do
    proxy = build_proxy(:factory)
    override = "override"

    proxy.sequence(:sequence, override)

    expect(FactoryBot::Sequence).to have_received(:new).
      with(:sequence, override)
  end

  it "creates a new sequence with a block" do
    sequence_block = Proc.new { |n| "user+#{n}@example.com" }
    proxy = build_proxy(:factory)
    proxy.sequence(:sequence, 1, &sequence_block)

    expect(FactoryBot::Sequence).to have_received(:new).
      with(:sequence, 1, &sequence_block)
  end
end

describe FactoryBot::DefinitionProxy, "#association" do
  it "declares an association" do
    definition = FactoryBot::Definition.new(:definition_name)
    proxy = FactoryBot::DefinitionProxy.new(definition)

    proxy.association(:association_name)

    expect(definition).to have_association_declaration(:association_name)
  end

  it "declares an association with options" do
    definition = FactoryBot::Definition.new(:definition_name)
    proxy = FactoryBot::DefinitionProxy.new(definition)

    proxy.association(:association_name, name: "Awesome")

    expect(definition).to have_association_declaration(:association_name).
      with_options(name: "Awesome")
  end

  context "when passing a block" do
    it "raises an error" do
      definition = FactoryBot::Definition.new(:post)
      proxy = FactoryBot::DefinitionProxy.new(definition)

      expect { proxy.association(:author) {} }.
        to raise_error(
          FactoryBot::AssociationDefinitionError,
          "Unexpected block passed to 'author' association in 'post' factory",
        )
    end
  end
end

describe FactoryBot::DefinitionProxy, "adding callbacks" do
  subject        { FactoryBot::Definition.new(:name) }
  let(:proxy)    { FactoryBot::DefinitionProxy.new(subject) }
  let(:callback) { -> { "my awesome callback!" } }

  context "#after(:build)" do
    before { proxy.after(:build, &callback) }
    it     { should have_callback(:after_build).with_block(callback) }
  end

  context "#after(:create)" do
    before { proxy.after(:create, &callback) }
    it     { should have_callback(:after_create).with_block(callback) }
  end

  context "#after(:stub)" do
    before { proxy.after(:stub, &callback) }
    it     { should have_callback(:after_stub).with_block(callback) }
  end

  context "#after(:stub, :create)" do
    before { proxy.after(:stub, :create, &callback) }
    it     { should have_callback(:after_stub).with_block(callback) }
    it     { should have_callback(:after_create).with_block(callback) }
  end

  context "#before(:stub, :create)" do
    before { proxy.before(:stub, :create, &callback) }
    it     { should have_callback(:before_stub).with_block(callback) }
    it     { should have_callback(:before_create).with_block(callback) }
  end

  context "#callback(:after_stub, :before_create)" do
    before { proxy.callback(:after_stub, :before_create, &callback) }
    it     { should have_callback(:after_stub).with_block(callback) }
    it     { should have_callback(:before_create).with_block(callback) }
  end
end

describe FactoryBot::DefinitionProxy, "#to_create" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  it "accepts a block to run in place of #save!" do
    to_create_block = ->(record) { record.persist }
    proxy.to_create(&to_create_block)
    expect(subject.to_create).to eq to_create_block
  end
end

describe FactoryBot::DefinitionProxy, "#factory" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  it "without options" do
    proxy.factory(:child)
    expect(proxy.child_factories).to include([:child, {}, nil])
  end

  it "with options" do
    proxy.factory(:child, awesome: true)
    expect(proxy.child_factories).to include([:child, { awesome: true }, nil])
  end

  it "with a block" do
    child_block = -> {}
    proxy.factory(:child, {}, &child_block)
    expect(proxy.child_factories).to include([:child, {}, child_block])
  end
end

describe FactoryBot::DefinitionProxy, "#trait" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  it "declares a trait" do
    male_trait = Proc.new { gender { "Male" } }
    proxy.trait(:male, &male_trait)
    expect(subject).to have_trait(:male).with_block(male_trait)
  end
end

describe FactoryBot::DefinitionProxy, "#initialize_with" do
  subject     { FactoryBot::Definition.new(:name) }
  let(:proxy) { FactoryBot::DefinitionProxy.new(subject) }

  it "defines the constructor on the definition" do
    constructor = Proc.new { Array.new }
    proxy.initialize_with(&constructor)
    expect(subject.constructor).to eq constructor
  end
end
