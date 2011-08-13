require 'spec_helper'

describe "accessing an undefined method on Factory that is defined on FactoryGirl" do
  let(:method_name) { :aliases }
  let(:return_value) { 'value' }
  let(:args) { [1, 2, 3] }

  before do
    $stderr.stubs(:puts)
    FactoryGirl.stubs(method_name => return_value)

    @result = Factory.send(method_name, *args)
  end

  it "prints a deprecation warning" do
    $stderr.should have_received(:puts).with(anything)
  end

  it "invokes that method on FactoryGirl" do
    FactoryGirl.should have_received(method_name).with(*args)
  end

  it "returns the value from the method on FactoryGirl" do
    @result.should == return_value
  end
end

describe "accessing an undefined method on Factory that is not defined on FactoryGirl" do
  it "raises a NoMethodError" do
    expect { Factory.send(:magic_beans) }.to raise_error(NoMethodError)
  end
end

describe "accessing an undefined constant on Factory that is defined on FactoryGirl" do
  before do
    @result = Factory::VERSION
  end

  it "returns that constant on FactoryGirl" do
    @result.should == FactoryGirl::VERSION
  end
end

describe "accessing an undefined constant on Factory that is undefined on FactoryGirl" do
  it "raises a NameError for Factory" do
    expect { Factory::BOGUS }.to raise_error(NameError, /Factory::BOGUS/)
  end
end

