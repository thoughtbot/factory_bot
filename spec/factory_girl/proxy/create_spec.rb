require 'spec_helper'

describe FactoryGirl::Proxy::Create do
  let(:instance)    { stub("created-instance", :save! => true) }
  let(:proxy_class) { stub("class", :new => instance) }

  subject { FactoryGirl::Proxy::Create.new(proxy_class) }

  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Create
  it_should_behave_like "proxy with standard getters and setters", :attribute_name, "attribute value!"
  it_should_behave_like "proxy with callbacks", :after_build
  it_should_behave_like "proxy with callbacks", :after_create

  it "runs a custom create block" do
    block_run = false
    block = lambda {|instance| block_run = true }
    subject.result(block)
    instance.should have_received(:save!).never
    block_run.should be_true
  end
end

describe FactoryGirl::Proxy::Create, "when running callbacks" do
  let(:instance)         { stub("created-instance", :save! => true) }
  let(:proxy_class)      { stub("class", :new => instance) }
  let!(:callback_result) { [] }

  let(:after_create_one) { FactoryGirl::Callback.new(:after_create, lambda { callback_result << :after_create_one }) }
  let(:after_create_two) { FactoryGirl::Callback.new(:after_create, lambda { callback_result << :after_create_two }) }
  let(:after_build_one)  { FactoryGirl::Callback.new(:after_build,  lambda { callback_result << :after_build_one }) }

  subject { FactoryGirl::Proxy::Create.new(proxy_class, [after_create_one, after_create_two, after_build_one]) }

  it "runs callbacks in the correct order" do
    subject.result(lambda {|instance| instance })
    callback_result.should == [:after_build_one, :after_create_one, :after_create_two]
  end
end
