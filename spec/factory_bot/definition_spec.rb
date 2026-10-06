describe FactoryBot::Definition do
  it "has a name" do
    name = "factory name"
    definition = described_class.new(name)

    expect(definition.name).to eq(name)
  end

  it "appends declarations with the same name until it is overridable" do
    definition = described_class.new(:name)
    first = FactoryBot::Declaration::Dynamic.new(:email, false, -> { "first" })
    second = FactoryBot::Declaration::Dynamic.new(:email, false, -> { "second" })

    definition.declare_attribute(first)
    definition.declare_attribute(second)

    expect(definition.declarations).to eq [first, second]
  end

  it "replaces declarations with the same name once overridable" do
    definition = described_class.new(:name)
    first = FactoryBot::Declaration::Dynamic.new(:email, false, -> { "first" })
    other = FactoryBot::Declaration::Dynamic.new(:name, false, -> { "other" })
    second = FactoryBot::Declaration::Dynamic.new(:email, false, -> { "second" })

    definition.declare_attribute(first)
    definition.declare_attribute(other)
    expect(definition.overridable).to eq definition
    definition.declare_attribute(second)

    expect(definition.declarations).to eq [other, second]
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
