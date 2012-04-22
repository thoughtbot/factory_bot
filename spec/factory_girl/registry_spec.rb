require 'spec_helper'

describe FactoryGirl::Registry do
  let(:registered_object)        { stub("registered object") }
  let(:second_registered_object) { stub("second registered object") }

  subject { FactoryGirl::Registry.new("Great thing") }

  it { should be_kind_of(Enumerable) }

  it "finds a registered object" do
    subject.register(:object_name, registered_object)
    subject.find(:object_name).should == registered_object
  end

  it "finds a registered object with square brackets" do
    subject.register(:object_name, registered_object)
    subject[:object_name].should == registered_object
  end

  it "raises when an object cannot be found" do
    expect { subject.find(:object_name) }.to raise_error(ArgumentError, "Great thing not registered: object_name")
  end

  it "adds and returns the object registered" do
    subject.register(:object_name, registered_object).should == registered_object
  end

  it "knows that an object is registered by symbol" do
    subject.register(:object_name, registered_object)
    subject.should be_registered(:object_name)
  end

  it "knows that an object is registered by string" do
    subject.register(:object_name, registered_object)
    subject.should be_registered("object_name")
  end

  it "knows when an object is not registered" do
    subject.should_not be_registered("bogus")
  end

  it "iterates registered objects" do
    subject.register(:first_object, registered_object)
    subject.register(:second_object, second_registered_object)
    subject.to_a.should == [registered_object, second_registered_object]
  end

  it "does not include duplicate objects with registered under different names" do
    subject.register(:first_object, registered_object)
    subject.register(:second_object, registered_object)
    subject.to_a.should == [registered_object]
  end

  it "clears registered factories" do
    subject.register(:object_name, registered_object)
    subject.clear
    subject.count.should be_zero
  end
end
