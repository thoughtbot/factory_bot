require 'spec_helper'

describe FactoryGirl::DefinitionProxy, "#add_attribute" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "raises if both a block and value are given" do
    expect {
      proxy.add_attribute(:something, "great") { "will raise!" }
    }.to raise_error(FactoryGirl::AttributeDefinitionError, "Both value and block given")
  end

  it "declares a static attribute on the factory" do
    proxy.add_attribute(:attribute_name, "attribute value")
    expect(subject).to have_static_declaration(:attribute_name).with_value("attribute value")
  end

  it "declares a dynamic attribute on the factory" do
    attribute_value = -> { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    expect(subject).to have_dynamic_declaration(:attribute_name).with_value(attribute_value)
  end
end

describe FactoryGirl::DefinitionProxy, "#add_attribute when the proxy ignores attributes" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject, true) }

  it "raises if both a block and value are given" do
    expect {
      proxy.add_attribute(:something, "great") { "will raise!" }
    }.to raise_error(FactoryGirl::AttributeDefinitionError, "Both value and block given")
  end

  it "declares a static attribute on the factory" do
    proxy.add_attribute(:attribute_name, "attribute value")
    expect(subject).to have_static_declaration(:attribute_name).ignored.with_value("attribute value")
  end

  it "declares a dynamic attribute on the factory" do
    attribute_value = -> { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    expect(subject).to have_dynamic_declaration(:attribute_name).ignored.with_value(attribute_value)
  end
end

describe FactoryGirl::DefinitionProxy, "#ignore" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "makes all attributes added ignored" do
    proxy.ignore do
      add_attribute(:attribute_name, "attribute value")
    end

    expect(subject).to have_static_declaration(:attribute_name).ignored.with_value("attribute value")
  end
end

describe FactoryGirl::DefinitionProxy, "#method_missing" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "declares an implicit declaration without args or a block" do
    proxy.bogus
    expect(subject).to have_implicit_declaration(:bogus).with_factory(subject)
  end

  it "declares an association when :factory is passed" do
    proxy.author factory: :user
    expect(subject).to have_association_declaration(:author).with_options(factory: :user)
  end

  it "declares a static attribute" do
    proxy.attribute_name "attribute value"
    expect(subject).to have_static_declaration(:attribute_name).with_value("attribute value")
  end

  it "declares a dynamic attribute" do
    attribute_value = -> { "dynamic attribute" }
    proxy.attribute_name(&attribute_value)
    expect(subject).to have_dynamic_declaration(:attribute_name).with_value(attribute_value)
  end
end

describe FactoryGirl::DefinitionProxy, "#sequence" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  before      { FactoryGirl::Sequence.stubs(:new) }

  it "creates a new sequence starting at 1" do
    proxy.sequence(:great)
    expect(FactoryGirl::Sequence).to have_received(:new).with(:great)
  end

  it "creates a new sequence with an overridden starting vaue" do
    proxy.sequence(:great, "C")
    expect(FactoryGirl::Sequence).to have_received(:new).with(:great, "C")
  end

  it "creates a new sequence with a block" do
    sequence_block = Proc.new {|n| "user+#{n}@example.com" }
    proxy.sequence(:great, 1, &sequence_block)
    expect(FactoryGirl::Sequence).to have_received(:new).with(:great, 1, &sequence_block)
  end
end

describe FactoryGirl::DefinitionProxy, "#association" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "declares an association" do
    proxy.association(:association_name)
    expect(subject).to have_association_declaration(:association_name)
  end

  it "declares an association with options" do
    proxy.association(:association_name, { name: "Awesome" })
    expect(subject).to have_association_declaration(:association_name).with_options(name: "Awesome")
  end
end

describe FactoryGirl::DefinitionProxy, "adding callbacks" do
  subject        { FactoryGirl::Definition.new }
  let(:proxy)    { FactoryGirl::DefinitionProxy.new(subject) }
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

describe FactoryGirl::DefinitionProxy, "#to_create" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "accepts a block to run in place of #save!" do
    to_create_block = ->(record) { record.persist }
    proxy.to_create(&to_create_block)
    expect(subject.to_create).to eq to_create_block
  end
end

describe FactoryGirl::DefinitionProxy, "#factory" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "without options" do
    proxy.factory(:child)
    expect(proxy.child_factories).to include([:child, {}, nil])
  end

  it "with options" do
    proxy.factory(:child, { awesome: true })
    expect(proxy.child_factories).to include([:child, { awesome: true }, nil])
  end

  it "with a block" do
    child_block = -> { }
    proxy.factory(:child, {}, &child_block)
    expect(proxy.child_factories).to include([:child, {}, child_block])
  end
end

describe FactoryGirl::DefinitionProxy, "#trait" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "declares a trait" do
    male_trait = Proc.new { gender("Male") }
    proxy.trait(:male, &male_trait)
    expect(subject).to have_trait(:male).with_block(male_trait)
  end
end

describe FactoryGirl::DefinitionProxy, "#initialize_with" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "defines the constructor on the definition" do
    constructor = Proc.new { Array.new }
    proxy.initialize_with(&constructor)
    expect(subject.constructor).to eq constructor
  end
end
