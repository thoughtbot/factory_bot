require 'spec_helper'

describe FactoryGirl::Attribute do
  let(:name)  { "user" }
  subject     { FactoryGirl::Attribute.new(name, false) }

  its(:name) { should eq name.to_sym }
  it { should_not be_association }

  it "raises an error when defining an attribute writer" do
    error_message = %{factory_girl uses 'test value' syntax rather than 'test = value'}
    expect {
      FactoryGirl::Attribute.new('test=', false)
    }.to raise_error(FactoryGirl::AttributeDefinitionError, error_message)
  end
end
