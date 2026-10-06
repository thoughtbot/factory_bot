describe FactoryBot::Registry do
  subject(:registry) { described_class.new("Thing") }

  it "finds items by symbol or string name" do
    item = Object.new
    registry.register(:thing, item)

    expect(registry.find(:thing)).to be item
    expect(registry.find("thing")).to be item
    expect(registry["thing"]).to be item
    expect(registry).to be_registered(:thing)
  end

  it "raises a did-you-mean friendly KeyError for unknown names" do
    registry.register(:widget, Object.new)

    expect { registry.find(:widgets) }.to raise_error(KeyError, 'Thing not registered: "widgets"')
    expect { registry.find(:widgets) }.to raise_did_you_mean_error
  end

  it "rejects duplicates unless replacing" do
    registry.register(:thing, 1)

    expect { registry.register("thing", 2) }
      .to raise_error(FactoryBot::DuplicateDefinitionError, "Thing already registered: thing")
    expect(registry.register(:thing, 2, replace: true)).to eq 2
    expect(registry.find(:thing)).to eq 2
  end

  it "enumerates each item once even when registered under aliases" do
    item = Object.new
    registry.register(:thing, item)
    registry.register(:alias, item)

    expect(registry.to_a).to eq [item]
  end
end
