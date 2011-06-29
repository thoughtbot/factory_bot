require 'spec_helper'

describe FactoryGirl::Proxy do
  before do
    @proxy = FactoryGirl::Proxy.new(Class.new)
  end

  it "should do nothing when asked to set an attribute to a value" do
    lambda { @proxy.set(:name, 'a name') }.should_not raise_error
  end

  it "should return nil when asked for an attribute" do
    @proxy.get_attr(:name).should be_nil
  end

  it "should call get for a missing method" do
    mock(@proxy).get(:name) { "it's a name" }
    @proxy.name.should == "it's a name"
  end

  describe "with ignored attributes" do
    before do
      @proxy.ignored_attributes = {
        :foo => "bar",
        :baz => 8,
        :nil_attr => nil
      }
      dont_allow(@proxy).get_attr
      dont_allow(@proxy).set_attr
    end

    it "#set stores the value rather than calling #set_attr" do
      @proxy.set(:baz, 5)
      @proxy.get(:baz).should == 5
    end

    it "#get returns the stored value of the ignored attribute without calling #get_attr" do
      @proxy.get(:foo).should == "bar"
    end

    it "recognizes nil as a valid value for an ignored attribute" do
      @proxy.get(:nil_attr).should be_nil
      @proxy.set(:baz, nil)
      @proxy.get(:baz).should be_nil
    end
  end

  it "should do nothing when asked to associate with another factory" do
    lambda { @proxy.associate(:owner, :user, {}) }.should_not raise_error
  end

  it "should raise an error when asked for the result" do
    lambda { @proxy.result(nil) }.should raise_error(NotImplementedError)
  end

  describe "when adding callbacks" do
    before do
      @first_block  = proc{ 'block 1' }
      @second_block = proc{ 'block 2' }
    end
    it "should add a callback" do
      @proxy.add_callback(:after_create, @first_block)
      @proxy.callbacks[:after_create].should be_eql([@first_block])
    end

    it "should add multiple callbacks of the same name" do
      @proxy.add_callback(:after_create, @first_block)
      @proxy.add_callback(:after_create, @second_block)
      @proxy.callbacks[:after_create].should be_eql([@first_block, @second_block])
    end

    it "should add multiple callbacks of different names" do
      @proxy.add_callback(:after_create, @first_block)
      @proxy.add_callback(:after_build,  @second_block)
      @proxy.callbacks[:after_create].should be_eql([@first_block])
      @proxy.callbacks[:after_build].should be_eql([@second_block])
    end
  end

  describe "when running callbacks" do
    before do
      @first_spy = Object.new
      @second_spy = Object.new
      stub(@first_spy).foo
      stub(@second_spy).foo
    end

    it "should run all callbacks with a given name" do
      @proxy.add_callback(:after_create, proc{ @first_spy.foo })
      @proxy.add_callback(:after_create, proc{ @second_spy.foo })
      @proxy.run_callbacks(:after_create)
      @first_spy.should have_received.foo
      @second_spy.should have_received.foo
    end

    it "should only run callbacks with a given name" do
      @proxy.add_callback(:after_create, proc{ @first_spy.foo })
      @proxy.add_callback(:after_build,  proc{ @second_spy.foo })
      @proxy.run_callbacks(:after_create)
      @first_spy.should have_received.foo
      @second_spy.should_not have_received.foo
    end

    it "should pass in the instance if the block takes an argument" do
      @proxy.instance_variable_set("@instance", @first_spy)
      @proxy.add_callback(:after_create, proc{|spy| spy.foo })
      @proxy.run_callbacks(:after_create)
      @first_spy.should have_received.foo
    end

    it "should pass in the proxy if the block takes two arguments" do
      @proxy.instance_variable_set("@instance", @first_spy)
      stub(@proxy).bar
      @proxy.add_callback(:after_create, proc {|spy, proxy| spy.foo; proxy.bar })
      @proxy.run_callbacks(:after_create)
      @first_spy.should have_received.foo
      @proxy.should have_received.bar
    end
  end
end
