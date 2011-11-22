require 'spec_helper'

describe FactoryGirl::Attribute::Static do
  let(:name)  { :first_name }
  let(:value) { "John" }
  let(:proxy) { stub("proxy") }

  subject { FactoryGirl::Attribute::Static.new(name, value, false) }

  its(:name) { should == name }

  it "returns the value when executing the proc" do
    subject.to_proc(proxy).call.should == value
  end
end

describe FactoryGirl::Attribute::Static, "with a string name" do
  subject    { FactoryGirl::Attribute::Static.new("name", nil, false) }
  its(:name) { should == :name }
end
