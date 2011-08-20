require 'spec_helper'

describe FactoryGirl::Proxy do
  subject { FactoryGirl::Proxy.new(Class.new) }

  it_should_behave_like "proxy without association support"

  it "doesn't raise when assigning a value to an attribute" do
    expect { subject.set(:name, "a name") }.to_not raise_error
  end

  it "returns nil for an attribute without a value" do
    subject.get(:name).should be_nil
  end

  it "calls get for a missing method" do
    subject.stubs(:get).with(:name).returns("it's a name")
    subject.name.should == "it's a name"
  end

  it "raises an error when asking for the result" do
    expect { subject.result(nil) }.to raise_error(NotImplementedError)
  end

  describe "when adding callbacks" do
    let(:block_1) { proc { "block 1" } }
    let(:block_2) { proc { "block 2" } }

    it "adds a callback" do
      subject.add_callback(:after_create, block_1)
      subject.callbacks[:after_create].should be_eql([block_1])
    end

    it "adds multiple callbacks of the same name" do
      subject.add_callback(:after_create, block_1)
      subject.add_callback(:after_create, block_2)
      subject.callbacks[:after_create].should be_eql([block_1, block_2])
    end

    it "adds multiple callbacks with different names" do
      subject.add_callback(:after_create, block_1)
      subject.add_callback(:after_build,  block_2)
      subject.callbacks[:after_create].should be_eql([block_1])
      subject.callbacks[:after_build].should be_eql([block_2])
    end
  end

  describe "when running callbacks" do
    let(:object_1_within_callback) { stub("call_in_create", :foo => true) }
    let(:object_2_within_callback) { stub("call_in_create", :foo => true) }

    it "runs all callbacks with a given name" do
      subject.add_callback(:after_create, proc { object_1_within_callback.foo })
      subject.add_callback(:after_create, proc { object_2_within_callback.foo })
      subject.run_callbacks(:after_create)
      object_1_within_callback.should have_received(:foo).once
      object_2_within_callback.should have_received(:foo).once
    end

    it "only runs callbacks with a given name" do
      subject.add_callback(:after_create, proc { object_1_within_callback.foo })
      subject.add_callback(:after_build,  proc { object_2_within_callback.foo })
      subject.run_callbacks(:after_create)
      object_1_within_callback.should have_received(:foo).once
      object_2_within_callback.should have_received(:foo).never
    end

    it "passes in the instance if the block takes an argument" do
      subject.instance_variable_set("@instance", object_1_within_callback)
      subject.add_callback(:after_create, proc {|spy| spy.foo })
      subject.run_callbacks(:after_create)
      object_1_within_callback.should have_received(:foo).once
    end

    it "passes in the instance and the proxy if the block takes two arguments" do
      subject.instance_variable_set("@instance", object_1_within_callback)
      proxy_instance = nil
      subject.add_callback(:after_create, proc {|spy, proxy| spy.foo; proxy_instance = proxy })
      subject.run_callbacks(:after_create)
      object_1_within_callback.should have_received(:foo).once
      proxy_instance.should == subject
    end
  end
end
