describe FactoryBot::Attribute::Sequence do
  let(:sequence_name) { :name }
  let(:name)          { :first_name }
  let(:sequence)      { FactoryBot::Sequence.new(sequence_name, 5) { |n| "Name #{n}" } }

  subject { FactoryBot::Attribute::Sequence.new(name, sequence_name, false) }
  before  { FactoryBot::Internal.register_sequence(sequence) }

  its(:name) { should eq name }

  it "assigns the next value in the sequence" do
    expect(subject.to_proc.call).to eq "Name 5"
  end
end
