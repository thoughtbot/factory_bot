require 'spec_helper'

describe FactoryGirl::Registry do
  let(:registered_object)        { stub("registered object") }
  let(:second_registered_object) { stub("second registered object") }

  subject { FactoryGirl::Registry.new("Great thing") }

  it { should be_kind_of(Enumerable) }

  it "finds a registered object" do
    subject.register(:object_name, registered_object)
    expect(subject.find(:object_name)).to eq registered_object
  end

  it "finds a registered object with square brackets" do
    subject.register(:object_name, registered_object)
    expect(subject[:object_name]).to eq registered_object
  end

  it "raises when an object cannot be found" do
    expect { subject.find(:object_name) }.to raise_error(ArgumentError, "Great thing not registered: object_name")
  end

  it "adds and returns the object registered" do
    expect(subject.register(:object_name, registered_object)).to eq registered_object
  end

  it "knows that an object is registered by symbol" do
    subject.register(:object_name, registered_object)
    expect(subject).to be_registered(:object_name)
  end

  it "knows that an object is registered by string" do
    subject.register(:object_name, registered_object)
    expect(subject).to be_registered("object_name")
  end

  it "knows when an object is not registered" do
    expect(subject).not_to be_registered("bogus")
  end

  it "iterates registered objects" do
    subject.register(:first_object, registered_object)
    subject.register(:second_object, second_registered_object)
    expect(subject.to_a).to eq [registered_object, second_registered_object]
  end

  it "does not include duplicate objects with registered under different names" do
    subject.register(:first_object, registered_object)
    subject.register(:second_object, registered_object)
    expect(subject.to_a).to eq [registered_object]
  end

  it "clears registered factories" do
    subject.register(:object_name, registered_object)
    subject.clear
    expect(subject.count).to be_zero
  end

  it "registers classes" do
    define_class("User")
    subject.register(User, registered_object)
    expect(subject.to_a).to eq [registered_object]
    expect(subject.find(:user)).to eq registered_object
    expect(subject.find(User)).to eq registered_object
  end
end
