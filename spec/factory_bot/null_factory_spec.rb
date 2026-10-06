describe FactoryBot::NullFactory do
  it "delegates defined traits to its definition" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory).to delegate(:defined_traits).to(:definition)
  end

  it "has a nil value for its compile attribute" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory.compile).to be_nil
  end

  it "has a nil value for its class_name attribute" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory.class_name).to be_nil
  end

  describe "#compiled" do
    it "has no attributes" do
      null_factory = FactoryBot::NullFactory.new

      expect(null_factory.compiled.attributes).to eq({})
    end

    it "has the global callbacks as its callbacks" do
      null_factory = FactoryBot::NullFactory.new

      expect(null_factory.compiled.callbacks).to eq FactoryBot::Internal.callbacks
    end

    it "has the global constructor as its constructor" do
      null_factory = FactoryBot::NullFactory.new

      expect(null_factory.compiled.constructor).to eq FactoryBot::Internal.constructor
    end

    it "has the global to_create as its to_create" do
      null_factory = FactoryBot::NullFactory.new

      expect(null_factory.compiled.to_create).to eq FactoryBot::Internal.to_create
    end
  end
end
