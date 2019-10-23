describe FactoryBot::Registry do
  it "is an enumerable" do
    registry = FactoryBot::Registry.new("Great thing")

    expect(registry).to be_kind_of(Enumerable)
  end

  it "finds a registered object" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    registry.register(:object_name, registered_object)

    expect(registry.find(:object_name)).to eq registered_object
  end

  it "finds a registered object with square brackets" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    registry.register(:object_name, registered_object)

    expect(registry[:object_name]).to eq registered_object
  end

  it "raises when an object cannot be found" do
    registry = FactoryBot::Registry.new("Great thing")

    expect { registry.find(:object_name) }.
      to raise_error(KeyError, "Great thing not registered: \"object_name\"")
  end

  it "adds and returns the object registered" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")

    expect(registry.register(:object_name, registered_object)).to eq registered_object
  end

  it "knows that an object is registered by symbol" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    registry.register(:object_name, registered_object)

    expect(registry).to be_registered(:object_name)
  end

  it "knows that an object is registered by string" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    registry.register(:object_name, registered_object)

    expect(registry).to be_registered("object_name")
  end

  it "knows when an object is not registered" do
    registry = FactoryBot::Registry.new("Great thing")

    expect(registry).not_to be_registered("bogus")
  end

  it "iterates registered objects" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    second_registered_object = double("second registered object")
    registry.register(:first_object, registered_object)
    registry.register(:second_object, second_registered_object)

    expect(registry.to_a).to eq [registered_object, second_registered_object]
  end

  it "does not include duplicate objects with registered under different names" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    registry.register(:first_object, registered_object)
    registry.register(:second_object, registered_object)

    expect(registry.to_a).to eq [registered_object]
  end

  it "clears registered factories" do
    registry = FactoryBot::Registry.new("Great thing")
    registered_object = double("registered object")
    registry.register(:object_name, registered_object)
    registry.clear

    expect(registry.count).to be_zero
  end
end
