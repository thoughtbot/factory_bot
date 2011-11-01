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

  it "tells the proxy to set the association when being added" do
    association = stub("association")
    proxy.stubs(:set => nil, :association => association)
    subject.add_to(proxy)
    proxy.should have_received(:set).with(subject, association)
    proxy.should have_received(:association).with(factory, overrides)
  end
end

describe FactoryGirl::Attribute::Association, "with a string name" do
  subject    { FactoryGirl::Attribute::Association.new("name", :user, {}) }
  its(:name) { should == :name }
end
