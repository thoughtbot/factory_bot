shared_examples_for "strategy without association support" do
  let(:factory) { double("associate_factory") }
  let(:attribute) { FactoryBot::Attribute::Association.new(:user, :user, {}) }

  def association_named(name, overrides)
    runner = FactoryBot::FactoryRunner.new(name, :build, [overrides])
    subject.association(runner)
  end

  before do
    allow(FactoryBot::Internal).to receive(:factory_by_name).and_return factory
    allow(factory).to receive(:compile)
    allow(factory).to receive(:run)
  end

  it "returns nil when accessing an association" do
    expect(association_named(:user, {})).to be_nil
  end
end

shared_examples_for "strategy with association support" do |factory_bot_strategy_name|
  let(:factory) { double("associate_factory") }

  def association_named(name, strategy, overrides)
    runner = FactoryBot::FactoryRunner.new(name, strategy, [overrides])
    subject.association(runner)
  end

  before do
    allow(FactoryBot::Internal).to receive(:factory_by_name).and_return factory
    allow(factory).to receive(:compile)
    allow(factory).to receive(:run)
  end

  it "runs the factory with the correct overrides" do
    association_named(:author, factory_bot_strategy_name, great: "value")
    expect(factory).to have_received(:run).with(factory_bot_strategy_name, great: "value")
  end

  it "finds the factory with the correct factory name" do
    association_named(:author, factory_bot_strategy_name, great: "value")
    expect(FactoryBot::Internal).to have_received(:factory_by_name).with(:author)
  end
end

shared_examples_for "strategy with strategy: :build" do |factory_bot_strategy_name|
  let(:factory) { double("associate_factory") }

  def association_named(name, overrides)
    runner = FactoryBot::FactoryRunner.new(name, overrides[:strategy], [overrides.except(:strategy)])
    subject.association(runner)
  end

  before do
    allow(FactoryBot::Internal).to receive(:factory_by_name).and_return factory
    allow(factory).to receive(:compile)
    allow(factory).to receive(:run)
  end

  it "runs the factory with the correct overrides" do
    association_named(:author, strategy: :build, great: "value")
    expect(factory).to have_received(:run).with(factory_bot_strategy_name, great: "value")
  end

  it "finds the factory with the correct factory name" do
    association_named(:author, strategy: :build, great: "value")
    expect(FactoryBot::Internal).to have_received(:factory_by_name).with(:author)
  end
end

shared_examples_for "strategy with callbacks" do |*callback_names|
  let(:result_instance) do
    define_class("ResultInstance") {
      attr_accessor :id
    }.new
  end

  let(:evaluation) do
    double("evaluation", object: result_instance, notify: true, create: nil)
  end

  it "runs the callbacks #{callback_names} with the evaluation's object" do
    subject.result(evaluation)
    callback_names.each do |name|
      expect(evaluation).to have_received(:notify).with(name, evaluation.object)
    end
  end

  it "returns the object from the evaluation" do
    expect(subject.result(evaluation)).to eq evaluation.object
  end
end
