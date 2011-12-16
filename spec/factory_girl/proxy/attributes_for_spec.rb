require 'spec_helper'

describe FactoryGirl::Proxy::AttributesFor do
  let(:result)             { { :name => "John Doe", :gender => "Male", :admin => false } }
  let(:attribute_assigner) { stub("attribute assigner", :hash => result) }

  it_should_behave_like "proxy without association support"

  it "returns the hash from the attribute assigner" do
    subject.result(attribute_assigner, lambda {|item| item }).should == result
  end

  it "does not run the to_create block" do
    expect do
      subject.result(attribute_assigner, lambda {|item| raise "failed" })
    end.to_not raise_error
  end
end
