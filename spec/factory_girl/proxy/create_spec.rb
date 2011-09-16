require 'spec_helper'

describe FactoryGirl::Proxy::Create do

  let(:instance)    { stub("created-instance", :save! => true) }
  let(:proxy_class) { stub("class", :new => instance) }

  subject { FactoryGirl::Proxy::Create.new(proxy_class) }

  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Create
  it_should_behave_like "proxy with standard getters and setters", :attribute_name, "attribute value!"
  it_should_behave_like "proxy with callbacks", :after_build
  it_should_behave_like "proxy with callbacks", :after_create

  it "saves the instance before returning the result" do
    subject.result(nil)
    instance.should have_received(:save!)
  end

  it "runs a custom create block" do
    block = stub('custom create block', :call => nil)
    subject.result(block)
    block.should have_received(:call).with(instance)
    instance.should have_received(:save!).never
  end

  context "callback execution order" do
    it "runs after_build callbacks before after_create callbacks" do
      ran = []
      after_create = FactoryGirl::Callback.new(:after_create, lambda { ran << :after_create })
      after_build = FactoryGirl::Callback.new(:after_build, lambda { ran << :after_build })
      subject.add_callback(after_create)
      subject.add_callback(after_build)

      subject.result(nil)

      ran.should == [:after_build, :after_create]
    end
  end
end
