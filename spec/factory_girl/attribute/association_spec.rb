require 'spec_helper'

describe FactoryGirl::Attribute::Association do
  let(:name)        { :author }
  let(:factory)     { :user }
  let(:overrides)   { { :first_name => "John" } }
  let(:association) { stub("association") }
  let(:proxy)       { stub("proxy", :association => association) }

  subject    { FactoryGirl::Attribute::Association.new(name, factory, overrides) }

  it         { should be_association }
  its(:name) { should == name }

  it "builds the association when calling the proc" do
    subject.to_proc(proxy).call.should == association
  end

  it "builds the association when calling the proc" do
    subject.to_proc(proxy).call
    proxy.should have_received(:association).with(factory, overrides)
  end
end

describe FactoryGirl::Attribute::Association, "with a string name" do
  subject    { FactoryGirl::Attribute::Association.new("name", :user, {}) }
  its(:name) { should == :name }
end
