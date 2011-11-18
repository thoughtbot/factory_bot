require 'spec_helper'

describe FactoryWoman::Attribute::Static do
  let(:name)  { :first_name }
  let(:value) { "John" }
  let(:proxy) { stub("proxy") }

  subject { FactoryWoman::Attribute::Static.new(name, value, false) }

  its(:name) { should == name }

  it "sets its static value on a proxy" do
    proxy.stubs(:set)
    subject.add_to(proxy)
    proxy.should have_received(:set).with(name, value)
  end
end

describe FactoryWoman::Attribute::Static, "with a string name" do
  subject    { FactoryWoman::Attribute::Static.new("name", nil, false) }
  its(:name) { should == :name }
end
