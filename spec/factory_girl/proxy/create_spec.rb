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
    let(:after_build_callback)  { stub("after_build callback", :foo => nil) }
    let(:after_create_callback) { stub("after_create callback", :foo => nil) }
    let(:callback_sequence)     { sequence("after_* callbacks") }

    it "runs after_build callbacks before after_create callbacks" do
      subject.add_callback(:after_build,  proc { after_build_callback.foo })
      subject.add_callback(:after_create, proc { after_create_callback.foo })

      after_build_callback.expects(:foo).once.in_sequence(callback_sequence)
      after_create_callback.expects(:foo).once.in_sequence(callback_sequence)

      subject.result(nil)
    end
  end
end
