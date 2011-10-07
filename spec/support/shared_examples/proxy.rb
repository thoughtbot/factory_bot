shared_examples_for "proxy without association support" do
  it "doesn't raise when asked to associate with another factory" do
    expect { subject.associate(:owner, :user, {}) }.to_not raise_error
  end

  it "does not call FactoryGirl.create when building an association" do
    FactoryGirl.stubs(:create)
    subject.association(:user)
    FactoryGirl.should have_received(:create).never
  end

  it "returns nil when building an association" do
    subject.set(:association, 'x')
    subject.association(:user).should be_nil
  end
end

shared_examples_for "proxy with association support" do |factory_girl_proxy_class|
  let(:factory_name)     { :user }
  let(:association_name) { :owner }
  let(:factory)          { stub("associate_factory") }
  let(:overrides)        { { :one => 1, :two => 2 } }

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
    instance.stubs(association_name => factory_name)
    factory.stubs(:run => factory_name)
    subject.stubs(:set)
  end

  it "sets a value for the association" do
    subject.associate(association_name, factory_name, {})
    subject.result(nil).send(association_name).should == factory_name
  end

  it "sets the association attribute as the factory" do
    subject.associate(association_name, factory_name, {})
    subject.should have_received(:set).with(association_name, factory_name)
  end

  it "runs the factory with the correct proxy class" do
    subject.associate(association_name, factory_name, {})
    factory.should have_received(:run).with(factory_girl_proxy_class, {})
  end

  it "runs the factory with the correct proxy class and overrides" do
    subject.associate(association_name, factory_name, overrides)
    factory.should have_received(:run).with(factory_girl_proxy_class, overrides)
  end
end

shared_examples_for "proxy with :method => :build" do |factory_girl_proxy_class|
  let(:factory_name)     { :user }
  let(:association_name) { :owner }
  let(:factory)          { stub("associate_factory") }
  let(:overrides)        { { :method => :build } }

  before do
    FactoryGirl.stubs(:factory_by_name => factory)
    instance.stubs(association_name => factory_name)
    factory.stubs(:run => factory_name)
    subject.stubs(:set)
  end

  it "sets a value for the association" do
    subject.associate(association_name, factory_name, overrides)
    subject.result(nil).send(association_name).should == factory_name
  end

  it "sets the association attribute as the factory" do
    subject.associate(association_name, factory_name, overrides)
    subject.should have_received(:set).with(association_name, factory_name)
  end

  it "runs the factory with the correct proxy class" do
    subject.associate(association_name, factory_name, overrides)
    factory.should have_received(:run).with(factory_girl_proxy_class, {})
  end
end

shared_examples_for "proxy with standard getters and setters" do |attribute, value|
  before do
    instance.stubs(:"#{attribute}=" => value, :"#{attribute}" => value)
  end

  describe "when setting an attribute" do
    before do
      subject.set(attribute, value)
    end

    its(attribute) { should == value }
    it { instance.should have_received(:"#{attribute}=").with(value) }
  end

  describe "when setting an ignored attribute" do
    before do
      subject.set_ignored(attribute, value)
    end

    it { instance.should have_received(:"#{attribute}=").with(value).never }
  end

  describe "when getting an attribute" do
    it { subject.get(attribute).should == value }

    it "retrieves the value from the instance" do
      subject.get(attribute)
      instance.should have_received(:"#{attribute}")
    end
  end
end

shared_examples_for "proxy with callbacks" do |callback_name|
  let(:callback) { stub("#{callback_name} callback", :foo => nil) }

  before do
    subject.add_callback(FactoryGirl::Callback.new(callback_name, proc { callback.foo }))
  end

  it "runs the #{callback_name} callback" do
    subject.result(nil)
    callback.should have_received(:foo).once
  end

  it "returns the proxy instance" do
    subject.result(nil).should == instance
  end
end
