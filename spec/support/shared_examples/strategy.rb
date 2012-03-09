shared_examples_for "strategy without association support" do
  let(:attribute) { FactoryGirl::Attribute::Association.new(:user, :user, {}) }

  def association_named(name, overrides)
    runner = FactoryGirl::FactoryRunner.new(name, FactoryGirl::Strategy::Build, [overrides])
    subject.association(runner)
  end

  it "returns nil when accessing an association" do
    association_named(:user, {}).should be_nil
  end

  it "does not attempt to look up the factory when accessing the association" do
    FactoryGirl.stubs(:factory_by_name)
    association_named(:awesome, {})
    FactoryGirl.should have_received(:factory_by_name).never
  end
end

shared_examples_for "strategy with association support" do |factory_girl_strategy_class|
  let(:factory) { stub("associate_factory") }

  def association_named(name, strategy, overrides)
    runner = FactoryGirl::FactoryRunner.new(name, strategy, [overrides])
    subject.association(runner)
  end

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
    factory.stubs(:compile)
    factory.stubs(:run)
  end

  it "runs the factory with the correct overrides" do
    association_named(:author, factory_girl_strategy_class, :great => "value")
    factory.should have_received(:run).with(factory_girl_strategy_class, :great => "value")
  end

  it "finds the factory with the correct factory name" do
    association_named(:author, factory_girl_strategy_class, :great => "value")
    FactoryGirl.should have_received(:factory_by_name).with(:author)
  end
end

shared_examples_for "strategy with :strategy => :build" do |factory_girl_strategy_class|
  let(:factory) { stub("associate_factory") }

  def association_named(name, overrides)
    strategy = FactoryGirl::StrategyCalculator.new(overrides[:strategy] || overrides[:method]).strategy
    runner = FactoryGirl::FactoryRunner.new(name, strategy, [overrides.except(:strategy, :method)])
    subject.association(runner)
  end

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
    factory.stubs(:compile)
    factory.stubs(:run)
  end

  it "runs the factory with the correct overrides" do
    association_named(:author, :strategy => :build, :great => "value")
    factory.should have_received(:run).with(factory_girl_strategy_class, { :great => "value" })
  end

  it "finds the factory with the correct factory name" do
    association_named(:author, :strategy => :build, :great => "value")
    FactoryGirl.should have_received(:factory_by_name).with(:author)
  end

  it "runs the factory with the correct overrides with :method" do
    association_named(:author, :method => :build, :great => "value")
    factory.should have_received(:run).with(factory_girl_strategy_class, { :great => "value" })
  end

  it "finds the factory with the correct factory name with :method" do
    association_named(:author, :method => :build, :great => "value")
    FactoryGirl.should have_received(:factory_by_name).with(:author)
  end
end

shared_examples_for "strategy with callbacks" do |*callback_names|
  let(:callback_observer) do
    define_class("CallbackObserver") do
      attr_reader :callbacks_called

      def initialize
        @callbacks_called = []
      end

      def update(callback_name, assigner)
        @callbacks_called << [callback_name, assigner]
      end
    end.new
  end

  let(:result_instance) do
    define_class("ResultInstance") do
      attr_accessor :id
    end.new
  end

  let(:assigner) { stub("attribute assigner", :object => result_instance) }

  before { subject.add_observer(callback_observer) }

  it "runs the callbacks #{callback_names} with the assigner's object" do
    subject.result(assigner, lambda {|instance| instance })
    callback_observer.callbacks_called.should == callback_names.map {|name| [name, assigner.object] }
  end

  it "returns the object from the assigner" do
    subject.result(assigner, lambda {|instance| instance }).should == assigner.object
  end
end
