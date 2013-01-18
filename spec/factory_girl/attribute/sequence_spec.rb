require 'spec_helper'

describe FactoryGirl::Attribute::Sequence do
  let(:sequence_name) { :name }
  let(:name)          { :first_name }
  let(:sequence)      { FactoryGirl::Sequence.new(sequence_name, 5) { |n| "Name #{n}" } }

  subject { FactoryGirl::Attribute::Sequence.new(name, sequence_name, false) }
  before  { FactoryGirl.register_sequence(sequence) }

  its(:name) { should eq name }

  it "assigns the next value in the sequence" do
    expect(subject.to_proc.call).to eq "Name 5"
  end
end
