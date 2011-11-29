require 'spec_helper'

describe FactoryGirl::Attribute::Sequence do
  let(:sequence_name) { :name }
  let(:name)          { :first_name }
  let(:sequence)      { FactoryGirl::Sequence.new(sequence_name, 5) { |n| "Name #{n}" } }

  subject { FactoryGirl::Attribute::Sequence.new(name, sequence_name, false) }
  before  { FactoryGirl.register_sequence(sequence) }

  its(:name) { should == name }

  it "assigns the next value in the sequence" do
    subject.to_proc.call.should == "Name 5"
  end
end
