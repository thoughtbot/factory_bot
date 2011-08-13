require 'spec_helper'

describe FactoryGirl::Proxy::Stub do
  before do
    @instance = stub("instance", :id= => nil, :id => 42)
    @class    = stub("class", :new => @instance)

    @stub = FactoryGirl::Proxy::Stub.new(@class)
  end

  it "should not be a new record" do
    @stub.result(nil).should_not be_new_record
  end

  it "should be persisted" do
    @stub.result(nil).should be_persisted
  end

  it "should not be able to connect to the database" do
    lambda { @stub.result(nil).reload }.should raise_error(RuntimeError)
  end

  describe "when a user factory exists" do
    before do
      @user = "user"
      @associated_factory = stub('associate-factory')
      FactoryGirl.stubs(:factory_by_name => @associated_factory)
    end

    describe "when asked to associate with another factory" do
      before do
        @instance.stubs(:owner => @user)
        @associated_factory.stubs(:run => @user)
        @stub.stubs(:set)
        @stub.associate(:owner, :user, {})
      end

      it "should set a value for the association" do
        @stub.result(nil).owner.should == @user
      end

      it "should set the owner as the user" do
        @stub.should have_received(:set).with(:owner, @user)
      end

      it "should create a stub correctly on the association" do
        @associated_factory.should have_received(:run).with(FactoryGirl::Proxy::Stub, {})
      end
    end

    it "should return the association when building one" do
      @associated_factory.stubs(:run => @user)
      @stub.association(:user).should == @user
      @associated_factory.should have_received(:run).with(FactoryGirl::Proxy::Stub, {})
    end

    describe "when asked for the result" do
      it "should return the actual instance" do
        @stub.result(nil).should == @instance
      end

      it "should run the :after_stub callback" do
        @spy = stub("after_stub callback", :foo => nil)
        @stub.add_callback(:after_stub, proc{ @spy.foo })
        @stub.result(nil)
        @spy.should have_received(:foo)
      end
    end
  end

  describe "with an existing attribute" do
    before do
      @value = "value"
      @instance.stubs(:attribute => @value, :attribute= => @value)
      @stub.set(:attribute, @value)
    end

    it "should to the resulting object" do
      @stub.attribute.should == 'value'
    end

    it "should set the attribute as the value" do
      @instance.should have_received(:attribute=).with(@value)
    end

    it "should retrieve the attribute" do
      @stub.attribute
      @instance.should have_received(:attribute)
    end

    it "should return that value when asked for that attribute" do
      @stub.get(:attribute).should == @value
    end
  end
end
