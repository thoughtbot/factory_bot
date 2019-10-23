describe FactoryBot::NullFactory do
  it "delegates defined traits to its definition" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory).to delegate(:defined_traits).to(:definition)
  end

  it "delegates callbacks to its definition" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory).to delegate(:callbacks).to(:definition)
  end

  it "delegates attributes to its definition" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory).to delegate(:attributes).to(:definition)
  end

  it "delegates constructor to its definition" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory).to delegate(:constructor).to(:definition)
  end

  it "has a nil value for its compile attribute" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory.compile).to be_nil
  end

  it "has a nil value for its class_name attribute" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory.class_name).to be_nil
  end

  it "has an instance of FactoryBot::AttributeList for its attributes attribute" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory.attributes).to be_an_instance_of(FactoryBot::AttributeList)
  end

  it "has FactoryBot::Evaluator as its evaluator class" do
    null_factory = FactoryBot::NullFactory.new

    expect(null_factory.evaluator_class).to eq FactoryBot::Evaluator
  end
end
