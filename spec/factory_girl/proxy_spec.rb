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
    it "adds a callback" do
      callback = FactoryGirl::Callback.new(:after_create, lambda {})
      subject.add_callback(callback)
      subject.callbacks[:after_create].should == [callback]
    end

    it "adds multiple callbacks of the same name" do
      one = FactoryGirl::Callback.new(:after_create, lambda {})
      two = FactoryGirl::Callback.new(:after_create, lambda {})
      subject.add_callback(one)
      subject.add_callback(two)
      subject.callbacks[:after_create].should == [one, two]
    end

    it "adds multiple callbacks with different names" do
      after_create = FactoryGirl::Callback.new(:after_create, lambda {})
      after_build = FactoryGirl::Callback.new(:after_build, lambda {})
      subject.add_callback(after_create)
      subject.add_callback(after_build)
      subject.callbacks[:after_create].should == [after_create]
      subject.callbacks[:after_build].should == [after_build]
    end
  end

  describe "when running callbacks" do
    it "runs all callbacks with a given name" do
      ran = []
      one = FactoryGirl::Callback.new(:after_create, lambda { ran << :one })
      two = FactoryGirl::Callback.new(:after_create, lambda { ran << :two })
      subject.add_callback(one)
      subject.add_callback(two)
      subject.run_callbacks(:after_create)
      ran.should == [:one, :two]
    end

    it "only runs callbacks with a given name" do
      ran = []
      after_create = FactoryGirl::Callback.new(:after_create, lambda { ran << :after_create })
      after_build = FactoryGirl::Callback.new(:after_build, lambda { ran << :after_build })
      subject.add_callback(after_create)
      subject.add_callback(after_build)
      subject.run_callbacks(:after_create)
      ran.should == [:after_create]
    end
  end
end
