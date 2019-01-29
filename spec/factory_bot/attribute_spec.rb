describe FactoryGirl::Attribute do
  let(:name)  { "user" }
  subject     { FactoryGirl::Attribute.new(name, false) }

  its(:name) { should eq name.to_sym }
  it { should_not be_association }
end
