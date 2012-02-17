require 'spec_helper'

describe FactoryGirl::Strategy::Create do
  it_should_behave_like "strategy with association support", FactoryGirl::Strategy::Create
  it_should_behave_like "strategy with callbacks", :after_build, :after_create

  it "runs a custom create block" do
    block_run = false
    block = lambda {|instance| block_run = true }
    subject.result(stub("assigner", :object => stub("result instance")), block)
    block_run.should be_true
  end
end
