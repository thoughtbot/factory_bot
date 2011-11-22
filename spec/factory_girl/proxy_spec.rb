require 'spec_helper'

describe FactoryGirl::Proxy do
  subject { FactoryGirl::Proxy.new(Class.new) }

  it_should_behave_like "proxy without association support"

  it "doesn't raise when assigning a value to an attribute" do
    name_attribute = FactoryGirl::Attribute::Static.new(:name, "great", false)
    expect { subject.set(name_attribute, lambda { "a name" }) }.to_not raise_error
  end

  it "calls get for a missing method" do
    subject.stubs(:get).with(:name).returns("it's a name")
    subject.name.should == "it's a name"
  end

  it "raises an error when asking for the result" do
    expect { subject.result(nil) }.to raise_error(NotImplementedError)
  end
end

describe FactoryGirl::Proxy, "when running callbacks" do
  let!(:callback_result) { [] }

  let(:after_create_one) { FactoryGirl::Callback.new(:after_create, lambda { callback_result << :after_create_one }) }
  let(:after_create_two) { FactoryGirl::Callback.new(:after_create, lambda { callback_result << :after_create_two }) }
  let(:after_build_one)  { FactoryGirl::Callback.new(:after_build,  lambda { callback_result << :after_build_one }) }

  subject { FactoryGirl::Proxy.new(Class.new, [after_create_one, after_create_two, after_build_one]) }

  it "runs callbacks in the correct order" do
    subject.run_callbacks(:after_create)
    callback_result.should == [:after_create_one, :after_create_two]
  end

  it "runs the correct callbacks based on name" do
    subject.run_callbacks(:after_build)
    callback_result.should == [:after_build_one]
  end
end

describe FactoryGirl::Proxy, ".ensure_strategy_exists!" do
  it "raises when passed a nonexistent strategy" do
    expect { FactoryGirl::Proxy.ensure_strategy_exists!(:nonexistent) }.to raise_error(ArgumentError, "Unknown strategy: nonexistent")
  end

  it "doesn't raise when passed a valid strategy" do
    expect { FactoryGirl::Proxy.ensure_strategy_exists!(:create) }.to_not raise_error
  end
end
