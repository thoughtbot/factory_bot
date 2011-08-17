require 'spec_helper'

describe FactoryGirl::Proxy::AttributesFor do
  let(:proxy_class) { stub("class") }

  subject { FactoryGirl::Proxy::AttributesFor.new(proxy_class) }

  it_should_behave_like "proxy without association support"

  it "returns a hash when asked for the result" do
    subject.result(nil).should be_kind_of(Hash)
  end

  context "after associating a factory" do
    let(:attribute) { :owner }

    before { subject.associate(attribute, :user, {}) }

    it "doesn't set that key in the resulting hash" do
      subject.result(nil).should_not have_key(attribute)
    end

    it "returns nil when asked for that attribute" do
      subject.get(attribute).should be_nil
    end
  end

  describe "after setting an attribute" do
    let(:attribute) { :attribute }
    let(:value)     { "value" }

    before { subject.set(attribute, value) }

    it "sets that value in the resulting hash" do
      subject.result(nil)[attribute].should == value
    end

    it "returns that value when asked for that attribute" do
      subject.get(attribute).should == value
    end
  end
end

