require 'spec_helper'

describe "accessing an undefined method on Factory that is defined on FactoryGirl" do
  let(:method_name)  { :aliases }
  let(:return_value) { 'value' }
  let(:args)         { [1, 2, 3] }

  before do
    FactoryGirl.stubs(method_name => return_value)
  end

  subject { Factory.send(method_name, *args) }

  it "prints a deprecation warning" do
    $stderr.stubs(:puts)
    subject
    $stderr.should have_received(:puts).with(anything)
  end

  it "invokes that method on FactoryGirl" do
    subject
    FactoryGirl.should have_received(method_name).with(*args)
  end

  it "returns the value from the method on FactoryGirl" do
    subject.should == return_value
  end
end

describe "accessing an undefined method on Factory that is not defined on FactoryGirl" do
  it "raises a NoMethodError" do
    expect { Factory.send(:magic_beans) }.to raise_error(NoMethodError)
  end
end

describe "accessing an undefined constant on Factory that is defined on FactoryGirl" do
  subject { Factory::VERSION }
  it      { should == FactoryGirl::VERSION }
end

describe "accessing an undefined constant on Factory that is undefined on FactoryGirl" do
  it "raises a NameError for Factory" do
    expect { Factory::BOGUS }.to raise_error(NameError, /Factory::BOGUS/)
  end
end
