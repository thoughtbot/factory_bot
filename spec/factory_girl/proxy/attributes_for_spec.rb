require 'spec_helper'

describe FactoryGirl::Proxy::AttributesFor do
  let(:proxy_class) { stub("class") }

  subject { FactoryGirl::Proxy::AttributesFor.new(proxy_class) }

  it_should_behave_like "proxy without association support"

  it "returns a hash when asked for the result" do
    subject.result(nil).should be_kind_of(Hash)
  end

  describe "after setting an attribute" do
    let(:attribute) { stub("attribute", :name => :attribute) }
    let(:value)     { "value" }

    before { subject.set(attribute, value) }

    it "sets that value in the resulting hash" do
      subject.result(nil)[:attribute].should == value
    end

    it "returns that value when asked for that attribute" do
      subject.get(:attribute).should == value
    end
  end
end

