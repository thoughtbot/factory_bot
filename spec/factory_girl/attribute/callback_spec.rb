require 'spec_helper'

describe FactoryGirl::Attribute::Callback do
  let(:name)  { :after_create }
  let(:block) { proc { "block" } }
  let(:proxy) { stub("proxy") }

  subject     { FactoryGirl::Attribute::Callback.new(name, block) }

  its(:name)  { should == name }

  it "set its callback on a proxy" do
    proxy.stubs(:add_callback)
    subject.add_to(proxy)
    proxy.should have_received(:add_callback).with(name, block)
  end
end

describe FactoryGirl::Attribute::Callback, "with a string name" do
  subject    { FactoryGirl::Attribute::Callback.new("name", nil) }
  its(:name) { should == :name }
end
