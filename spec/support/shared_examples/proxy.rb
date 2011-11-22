shared_examples_for "proxy without association support" do
  let(:attribute) { FactoryGirl::Attribute::Association.new(:user, :user, {}) }

  it "does not call FactoryGirl.create when building an association" do
    FactoryGirl.stubs(:create)
    subject.set(attribute, lambda { "awesome" })
    FactoryGirl.should have_received(:create).never
  end

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

shared_examples_for "proxy with standard getters and setters" do |attribute, value|
  let(:attribute_instance) { stub("attribute #{attribute}", :name => attribute) }

  before do
    instance.stubs(:"#{attribute}=" => value, :"#{attribute}" => value)
  end

  describe "when setting an attribute" do
    before do
      subject.set(attribute_instance, lambda { value })
      subject.result(lambda {|instance| instance })
    end

    its(attribute) { should == value }
    it { instance.should have_received(:"#{attribute}=").with(value) }
  end

  describe "when setting an ignored attribute" do
    before do
      subject.set_ignored(attribute_instance, lambda { value })
      subject.result(lambda {|instance| instance })
    end

    it { instance.should have_received(:"#{attribute}=").with(value).never }
  end

  describe "when getting an attribute" do
    before do
      subject.set(attribute_instance, lambda { value })
      subject.result(lambda {|instance| instance })
    end

    it { subject.get(attribute).should == value }
  end
end

shared_examples_for "proxy with callbacks" do |callback_name|
  let(:callback_instance) { stub("#{callback_name} callback", :foo => nil) }
  let(:callback) { FactoryGirl::Callback.new(callback_name, proc { callback_instance.foo }) }

  subject        { described_class.new(proxy_class, [callback]) }

  it "runs the #{callback_name} callback" do
    subject.result(lambda {|instance| instance })
    callback_instance.should have_received(:foo).once
  end

  it "returns the proxy instance" do
    subject.result(lambda {|instance| instance }).should == instance
  end
end
