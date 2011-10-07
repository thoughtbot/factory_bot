require 'spec_helper'

describe FactoryGirl::Attribute do
  let(:name)  { "user" }
  let(:proxy) { stub("proxy") }
  subject     { FactoryGirl::Attribute.new(name, false) }

  its(:name) { should == name.to_sym }
  it { should_not be_association }

  it "doesn't set any attributes on a proxy when added" do
    proxy.stubs(:set)
    subject.add_to(proxy)
    proxy.should have_received(:set).never
  end

  it "raises an error when defining an attribute writer" do
    error_message = %{factory_girl uses 'f.test value' syntax rather than 'f.test = value'}
    expect {
      FactoryGirl::Attribute.new('test=', false)
    }.to raise_error(FactoryGirl::AttributeDefinitionError, error_message)
  end

  it "returns nil when compared to a non-attribute" do
    (subject <=> "foo").should be_nil
  end

  it "uses priority to perform comparisons" do
    second_attribute = FactoryGirl::Attribute.new('name', false)
    (subject <=> second_attribute).should be_zero
  end
end
