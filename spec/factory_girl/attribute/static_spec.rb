require 'spec_helper'

describe FactoryGirl::Attribute::Static do
  let(:name)  { :first_name }
  let(:value) { "John" }
  let(:proxy) { stub("proxy") }

  subject { FactoryGirl::Attribute::Static.new(name, value) }

  its(:name) { should == name }

  it "sets its static value on a proxy" do
    proxy.stubs(:set)
    subject.add_to(proxy)
    proxy.should have_received(:set).with(name, value, false)
  end
end

describe FactoryGirl::Attribute::Static, "with a string name" do
  subject    { FactoryGirl::Attribute::Static.new("name", nil) }
  its(:name) { should == :name }
end
