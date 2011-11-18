require 'spec_helper'

describe FactoryWoman::Proxy do
  subject { FactoryWoman::Proxy.new(Class.new) }

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
end

describe FactoryWoman::Proxy, "when running callbacks" do
  let!(:callback_result) { [] }

  let(:after_create_one) { FactoryWoman::Callback.new(:after_create, lambda { callback_result << :after_create_one }) }
  let(:after_create_two) { FactoryWoman::Callback.new(:after_create, lambda { callback_result << :after_create_two }) }
  let(:after_build_one)  { FactoryWoman::Callback.new(:after_build,  lambda { callback_result << :after_build_one }) }

  subject { FactoryWoman::Proxy.new(Class.new, [after_create_one, after_create_two, after_build_one]) }

  it "runs callbacks in the correct order" do
    subject.run_callbacks(:after_create)
    callback_result.should == [:after_create_one, :after_create_two]
  end

  it "runs the correct callbacks based on name" do
    subject.run_callbacks(:after_build)
    callback_result.should == [:after_build_one]
  end
end

describe FactoryWoman::Proxy, ".ensure_strategy_exists!" do
  it "raises when passed a nonexistent strategy" do
    expect { FactoryWoman::Proxy.ensure_strategy_exists!(:nonexistent) }.to raise_error(ArgumentError, "Unknown strategy: nonexistent")
  end

  it "doesn't raise when passed a valid strategy" do
    expect { FactoryWoman::Proxy.ensure_strategy_exists!(:create) }.to_not raise_error
  end
end
