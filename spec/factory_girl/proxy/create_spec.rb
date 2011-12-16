require 'spec_helper'

describe FactoryGirl::Proxy::Create do
  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Create
  it_should_behave_like "proxy with callbacks", :after_build, :after_create

  it "runs a custom create block" do
    block_run = false
    block = lambda {|instance| block_run = true }
    subject.result(stub("assigner", :object => stub("result instance")), block)
    block_run.should be_true
  end
end
