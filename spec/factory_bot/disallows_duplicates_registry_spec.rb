describe FactoryBot::Decorator::DisallowsDuplicatesRegistry do
  it "delegates #register to the registry when not registered" do
    registry = double("registry", name: "Great thing", register: true)
    decorator = FactoryBot::Decorator::DisallowsDuplicatesRegistry.new(registry)
    allow(registry).to receive(:registered?).and_return false
    decorator.register(:awesome, {})

    expect(registry).to have_received(:register).with(:awesome, {})
  end

  it "raises when attempting to #register a previously registered strategy" do
    registry = double("registry", name: "Great thing", register: true)
    decorator = FactoryBot::Decorator::DisallowsDuplicatesRegistry.new(registry)
    allow(registry).to receive(:registered?).and_return true

    expect { decorator.register(:same_name, {}) }
      .to raise_error(FactoryBot::DuplicateDefinitionError, "Great thing already registered: same_name")
  end
end
