describe FactoryBot::DefinitionProxy, "#add_attribute" do
  it "declares a dynamic attribute on the factory when the proxy respects attributes" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    attribute_value = -> { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)

    expect(definition).to have_dynamic_declaration(:attribute_name)
      .with_value(attribute_value)
  end

  it "declares a dynamic attribute on the factory when the proxy ignores attributes" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition, true)
    attribute_value = -> { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    expect(definition).to have_dynamic_declaration(:attribute_name)
      .ignored
      .with_value(attribute_value)
  end
end

describe FactoryBot::DefinitionProxy, "#transient" do
  it "makes all attributes added ignored" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    attribute_value = -> { "dynamic_attribute" }
    proxy.transient do
      add_attribute(:attribute_name, &attribute_value)
    end

    expect(definition).to have_dynamic_declaration(:attribute_name)
      .ignored
      .with_value(attribute_value)
  end
end

describe FactoryBot::DefinitionProxy, "#method_missing" do
  it "declares an implicit declaration when called without args or a block" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    proxy.bogus

    expect(definition).to have_implicit_declaration(:bogus).with_factory(definition)
  end

  it "declares an association when called with a ':factory' key" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    proxy.author factory: :user

    expect(definition).to have_association_declaration(:author)
      .with_options(factory: :user)
  end

  it "declares a dynamic attribute when called with a block" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    attribute_value = -> { "dynamic attribute" }
    proxy.attribute_name(&attribute_value)

    expect(definition).to have_dynamic_declaration(:attribute_name)
      .with_value(attribute_value)
  end

  it "raises a NoMethodError when called with a static-attribute-like argument" do
    definition = FactoryBot::Definition.new(:broken)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    invalid_call = -> { proxy.static_attributes_are_gone "true" }

    expect(&invalid_call).to raise_error(
      NoMethodError,
      /'static_attributes_are_gone'.*'broken' factory.*Did you mean\? 'static_attributes_are_gone \{ "true" \}'/m
    )
  end

  it "raises an AssociationDefinitionError when called with a `:factory`-key and providing a block" do
    definition = FactoryBot::Definition.new(:user)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    invalid_call = lambda do
      proxy.author(factory: :user) { :this_should_raise_an_error }
    end

    expect(invalid_call).to raise_error(
      FactoryBot::AssociationDefinitionError,
      "Unexpected block passed to 'author' association in 'user' factory"
    )
  end
end

describe FactoryBot::DefinitionProxy, "#sequence" do
  def build_proxy(factory_name)
    definition = FactoryBot::Definition.new(factory_name)
    FactoryBot::DefinitionProxy.new(definition)
  end

  it "creates a new sequence starting at 1" do
    allow(FactoryBot::Sequence).to receive(:new).and_call_original
    proxy = build_proxy(:factory)

    proxy.sequence(:sequence)

    expect(FactoryBot::Sequence).to have_received(:new).with(:sequence, {uri_paths: []})
  end

  it "creates a new sequence with an overridden starting value" do
    allow(FactoryBot::Sequence).to receive(:new).and_call_original
    proxy = build_proxy(:factory)
    override = "override"

    proxy.sequence(:sequence, override)

    expect(FactoryBot::Sequence).to have_received(:new)
      .with(:sequence, override, {uri_paths: []})
  end

  it "creates a new sequence with a block" do
    allow(FactoryBot::Sequence).to receive(:new).and_call_original
    sequence_block = proc { |n| "user+#{n}@example.com" }
    proxy = build_proxy(:factory)
    proxy.sequence(:sequence, 1, &sequence_block)

    expect(FactoryBot::Sequence).to have_received(:new)
      .with(:sequence, 1, {uri_paths: []}, &sequence_block)
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

    expect(definition).to have_association_declaration(:association_name)
      .with_options(name: "Awesome")
  end

  it "when passing a block raises an error" do
    definition = FactoryBot::Definition.new(:post)
    proxy = FactoryBot::DefinitionProxy.new(definition)

    expect { proxy.association(:author) {} }
      .to raise_error(
        FactoryBot::AssociationDefinitionError,
        "Unexpected block passed to 'author' association in 'post' factory"
      )
  end
end

describe FactoryBot::DefinitionProxy, "adding callbacks" do
  it "adding a :before_all callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.before(:all, &callback)

    expect(definition).to have_callback(:before_all).with_block(callback)
  end

  it "adding an :after_all callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.after(:all, &callback)

    expect(definition).to have_callback(:after_all).with_block(callback)
  end

  it "adding an :after_build callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.after(:build, &callback)

    expect(definition).to have_callback(:after_build).with_block(callback)
  end

  it "adding an :after_create callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.after(:create, &callback)

    expect(definition).to have_callback(:after_create).with_block(callback)
  end

  it "adding an :after_stub callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.after(:stub, &callback)
    expect(definition).to have_callback(:after_stub).with_block(callback)
  end

  it "adding both an :after_stub and an :after_create callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.after(:stub, :create, &callback)

    expect(definition).to have_callback(:after_stub).with_block(callback)
    expect(definition).to have_callback(:after_create).with_block(callback)
  end

  it "adding both a :before_stub and a :before_create callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.before(:stub, :create, &callback)

    expect(definition).to have_callback(:before_stub).with_block(callback)
    expect(definition).to have_callback(:before_create).with_block(callback)
  end

  it "adding both an :after_stub and a :before_create callback succeeds" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    callback = -> { "my awesome callback!" }

    proxy.callback(:after_stub, :before_create, &callback)

    expect(definition).to have_callback(:after_stub).with_block(callback)
    expect(definition).to have_callback(:before_create).with_block(callback)
  end
end

describe FactoryBot::DefinitionProxy, "#to_create" do
  it "accepts a block to run in place of #save!" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    to_create_block = ->(record) { record.persist }
    proxy.to_create(&to_create_block)

    expect(definition.to_create).to eq to_create_block
  end
end

describe FactoryBot::DefinitionProxy, "#factory" do
  it "without options" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    proxy.factory(:child)

    expect(proxy.child_factories).to include([:child, {}, nil])
  end

  it "with options" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    proxy.factory(:child, awesome: true)

    expect(proxy.child_factories).to include([:child, {awesome: true}, nil])
  end

  it "with a block" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    child_block = -> {}
    proxy.factory(:child, {}, &child_block)

    expect(proxy.child_factories).to include([:child, {}, child_block])
  end
end

describe FactoryBot::DefinitionProxy, "#trait" do
  it "declares a trait" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    male_trait = proc { gender { "Male" } }
    proxy.trait(:male, &male_trait)

    expect(definition).to have_trait(:male).with_block(male_trait)
  end
end

describe FactoryBot::DefinitionProxy, "#initialize_with" do
  it "defines the constructor on the definition" do
    definition = FactoryBot::Definition.new(:name)
    proxy = FactoryBot::DefinitionProxy.new(definition)
    constructor = proc { [] }
    proxy.initialize_with(&constructor)

    expect(definition.constructor).to eq constructor
  end
end
