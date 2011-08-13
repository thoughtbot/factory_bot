require 'spec_helper'

describe FactoryGirl::Attribute::Association do
  let(:name)      { :author }
  let(:factory)   { :user }
  let(:overrides) { { :first_name => "John" } }
  let(:proxy)     { stub("proxy") }

  subject       { FactoryGirl::Attribute::Association.new(name, factory, overrides) }

  it            { should be_association }
  its(:name)    { should == name }
  its(:factory) { should == factory }

  it "tells the proxy to create an association when being added" do
    proxy.stubs(:associate)
    subject.add_to(proxy)
    proxy.should have_received(:associate).with(name, factory, overrides)
  end
end

describe FactoryGirl::Attribute::Association, "with a string name" do
  subject    { FactoryGirl::Attribute::Association.new("name", :user, {}) }
  its(:name) { should == :name }
end
