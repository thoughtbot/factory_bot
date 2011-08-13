require 'spec_helper'

describe FactoryGirl::Proxy::Build do
  before do
    @instance = stub("built-instance", :attribute => "value", :attribute= => nil, :owner= => nil)
    @class    = stub("class", :new => @instance)
    @proxy    = FactoryGirl::Proxy::Build.new(@class)
  end

  it "should instantiate the class" do
    @class.should have_received(:new)
  end

  describe "when asked to associate with another factory" do
    before do
      @association = "associated-instance"
      @associated_factory = stub("associated-factory", :run => @association)
      FactoryGirl.stubs(:factory_by_name => @associated_factory)
      @overrides = { 'attr' => 'value' }
      @proxy.associate(:owner, :user, @overrides)
    end

    it "should create the associated instance" do
      @associated_factory.should have_received(:run).with(FactoryGirl::Proxy::Create, @overrides)
    end

    it "should set the associated instance" do
      @instance.should have_received(:owner=).with(@association)
    end
  end

  it "should run create when building an association" do
    association = "associated-instance"
    associated_factory = stub("associated-factory", :run => association)
    FactoryGirl.stubs(:factory_by_name => associated_factory)
    overrides = { 'attr' => 'value' }
    @proxy.association(:user, overrides).should == association
    associated_factory.should have_received(:run).with(FactoryGirl::Proxy::Create, overrides)
  end

  it "should return the built instance when asked for the result" do
    @proxy.result(nil).should == @instance
  end

  it "should run the :after_build callback when retrieving the result" do
    thing_to_call = stub("object", :foo => nil)
    @proxy.add_callback(:after_build, proc{ thing_to_call.foo })
    @proxy.result(nil)
    thing_to_call.should have_received(:foo)
  end

  describe "when setting an attribute" do
    before do
      @instance.stubs(:attributes=)
      @proxy.set(:attribute, 'value')
    end

    it "should set that value" do
      @instance.should have_received(:attribute=).with('value')
    end
  end

  describe "when getting an attribute" do
    before do
      @result = @proxy.get(:attribute)
    end

    it "should ask the built class for the value" do
      @instance.should have_received(:attribute)
    end

    it "should return the value for that attribute" do
      @result.should == 'value'
    end
  end
end

