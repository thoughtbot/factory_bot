shared_examples_for "proxy without association support" do
  let(:attribute) { FactoryGirl::Attribute::Association.new(:user, :user, {}) }

  it "returns nil when accessing an association" do
    subject.association(:user, {}).should be_nil
  end

  it "does not attempt to look up the factory when accessing the association" do
    FactoryGirl.stubs(:factory_by_name)
    subject.association(:awesome)
    FactoryGirl.should have_received(:factory_by_name).never
  end
end

shared_examples_for "proxy with association support" do |factory_girl_proxy_class|
  let(:factory)      { stub("associate_factory") }
  let(:overrides)    { { :great => "value" } }
  let(:factory_name) { :author }

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
    factory.stubs(:run)
  end

  it "runs the factory with the correct overrides" do
    subject.association(factory_name, overrides)
    factory.should have_received(:run).with(factory_girl_proxy_class, overrides)
  end

  it "finds the factory with the correct factory name" do
    subject.association(factory_name, overrides)
    FactoryGirl.should have_received(:factory_by_name).with(factory_name)
  end
end

shared_examples_for "proxy with :method => :build" do |factory_girl_proxy_class|
  let(:factory)      { stub("associate_factory") }
  let(:overrides)    { { :method => :build, :great => "value" } }
  let(:factory_name) { :author }

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
    factory.stubs(:run)
  end

  it "runs the factory with the correct overrides" do
    subject.association(factory_name, overrides)
    factory.should have_received(:run).with(factory_girl_proxy_class, { :great => "value" })
  end

  it "finds the factory with the correct factory name" do
    subject.association(factory_name, overrides)
    FactoryGirl.should have_received(:factory_by_name).with(factory_name)
  end
end

shared_examples_for "proxy with callbacks" do |*callback_names|
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
