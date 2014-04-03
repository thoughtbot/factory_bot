require 'spec_helper'

describe FactoryGirl::Attribute::Association do
  let(:name)        { :author }
  let(:factory)     { :user }
  let(:overrides)   { { first_name: "John" } }
  let(:association) { stub("association") }

  subject { FactoryGirl::Attribute::Association.new(name, factory, overrides) }
  before  { subject.stubs(association: association) }

  it         { should be_association }
  its(:name) { should eq name }

  it "builds the association when calling the proc" do
    expect(subject.to_proc.call).to eq association
  end

  it "builds the association when calling the proc" do
    subject.to_proc.call
    expect(subject).to have_received(:association).with(factory, overrides)
  end
end

describe FactoryGirl::Attribute::Association, "with an override class" do
  let(:name)        { :author }
  let(:factory)     { :user }
  let(:association) { stub("association", becomes: true) }
  let(:override_class) { stub("override_class") }

  subject { FactoryGirl::Attribute::Association.new(name, factory, {}, override_class) }
  before  { subject.stubs(association: association) }

  it "built assoication is converted to override_class" do
    subject.to_proc.call
    expect(association).to have_received(:becomes).with(override_class)
  end
end

describe FactoryGirl::Attribute::Association, "with a string name" do
  subject    { FactoryGirl::Attribute::Association.new("name", :user, {}) }
  its(:name) { should eq :name }
end
