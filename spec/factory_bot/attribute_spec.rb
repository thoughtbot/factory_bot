describe FactoryBot::Attribute do
  let(:name)  { "user" }
  subject     { FactoryBot::Attribute.new(name, false) }

  its(:name) { should eq name.to_sym }
  it { should_not be_association }

  it "raises an error when defining an attribute writer" do
    error_message = %{factory_bot uses 'test value' syntax rather than 'test = value'}
    expect {
      FactoryBot::Attribute.new('test=', false)
    }.to raise_error(FactoryBot::AttributeDefinitionError, error_message)
  end
end
