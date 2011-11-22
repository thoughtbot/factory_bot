require 'spec_helper'

describe FactoryGirl::Attribute do
  let(:name)  { "user" }
  let(:proxy) { stub("proxy") }
  subject     { FactoryGirl::Attribute.new(name, false) }

  its(:name) { should == name.to_sym }
  it { should_not be_association }

  it "raises an error when defining an attribute writer" do
    error_message = %{factory_girl uses 'f.test value' syntax rather than 'f.test = value'}
    expect {
      FactoryGirl::Attribute.new('test=', false)
    }.to raise_error(FactoryGirl::AttributeDefinitionError, error_message)
  end
end
