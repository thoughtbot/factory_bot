describe FactoryBot::Definition do
  it "delegates :declare_attribute to declarations" do
    definition = described_class.new(:name)

    expect(definition).to delegate(:declare_attribute).to(:declarations)
  end

  it "creates a new attribute list with the name passed when given a name" do
    name = "great name"
    allow(FactoryBot::DeclarationList).to receive(:new)

    FactoryBot::Definition.new(name)

    expect(FactoryBot::DeclarationList).to have_received(:new).with(name)
  end

  it "has a name" do
    name = "factory name"
    definition = described_class.new(name)

    expect(definition.name).to eq(name)
  end

  it "has an overridable declaration list" do
    list = double("declaration list", overridable: true)
    allow(FactoryBot::DeclarationList).to receive(:new).and_return list
    definition = described_class.new(:name)

    expect(definition.overridable).to eq definition
    expect(list).to have_received(:overridable).once
  end

  it "maintains a list of traits" do
    trait1 = double(:trait)
    trait2 = double(:trait)
    definition = described_class.new(:name)
    definition.define_trait(trait1)
    definition.define_trait(trait2)

    expect(definition.defined_traits).to include(trait1, trait2)
  end

  it "adds only unique traits" do
    trait1 = double(:trait)
    definition = described_class.new(:name)
    definition.define_trait(trait1)
    definition.define_trait(trait1)

    expect(definition.defined_traits.size).to eq 1
  end

  it "maintains a list of callbacks" do
    callback1 = "callback1"
    callback2 = "callback2"
    definition = described_class.new(:name)
    definition.add_callback(callback1)
    definition.add_callback(callback2)

    expect(definition.callbacks).to eq [callback1, callback2]
  end

  it "doesn't expose a separate create strategy when none is specified" do
    definition = described_class.new(:name)

    expect(definition.to_create).to be_nil
  end

  it "exposes a non-default create strategy when one is provided by the user" do
    definition = described_class.new(:name)
    block = proc {}
    definition.to_create(&block)

    expect(definition.to_create).to eq block
  end

  it "maintains a list of enum fields" do
    definition = described_class.new(:name)

    enum_field = double("enum_field")

    definition.register_enum(enum_field)

    expect(definition.registered_enums).to include(enum_field)
  end
end
