require 'spec_helper'

describe FactoryWoman::Attribute::Sequence do
  let(:sequence_name) { :name }
  let(:name)          { :first_name }
  let(:sequence)      { FactoryWoman::Sequence.new(sequence_name, 5) { |n| "Name #{n}" } }
  let(:proxy)         { stub("proxy") }

  subject { FactoryWoman::Attribute::Sequence.new(name, sequence_name, false) }
  before  { FactoryWoman.register_sequence(sequence) }

  its(:name) { should == name }

  it "assigns the next value in the sequence" do
    proxy.stubs(:set)
    subject.add_to(proxy)
    proxy.should have_received(:set).with(name, "Name 5")
  end
end
