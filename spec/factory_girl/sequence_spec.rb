require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject    { FactoryGirl::Sequence.new(name) { |n| "=#{n}" } }

    its(:name)  { should eq name }
    its(:names) { should eq [name] }
    its(:next)  { should eq "=1" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=2" }
    end
  end

  describe "a custom sequence" do
    subject    { FactoryGirl::Sequence.new(:name, "A") { |n| "=#{n}" } }
    its(:next) { should eq "=A" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=B" }
    end
  end

  describe "a sequence with aliases using default value" do
    subject     { FactoryGirl::Sequence.new(:test, aliases: [:alias, :other]) { |n| "=#{n}" } }
    its(:next)  { should eq "=1" }
    its(:names) { should eq [:test, :alias, :other] }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=2" }
    end
  end

  describe "a sequence with custom value and aliases" do
    subject    { FactoryGirl::Sequence.new(:test, 3, aliases: [:alias, :other]) { |n| "=#{n}" } }
    its(:next) { should eq "=3" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=4" }
    end
  end

  describe "a basic sequence without a block" do
    subject    { FactoryGirl::Sequence.new(:name) }
    its(:next) { should eq 1 }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq 2 }
    end
  end

  describe "a custom sequence without a block" do
    subject    { FactoryGirl::Sequence.new(:name, "A") }
    its(:next) { should eq "A" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "B" }
    end
  end

  describe "iterating over items in an enumerator" do
    subject { FactoryGirl::Sequence.new(:name, %w[foo bar].to_enum) { |n| "=#{n}" } }

    it "navigates to the next items until no items remain" do
      expect(subject.next).to eq "=foo"
      expect(subject.next).to eq "=bar"
      expect { subject.next }.to raise_error(StopIteration)
    end
  end

  describe "a custom sequence and scope" do
    subject { FactoryGirl::Sequence.new(:name, 'A') { |n| "=#{n}#{foo}" } }
    let(:scope) { stub('scope', foo: 'attribute') }

    it 'increments within the correct scope' do
      expect(subject.next(scope)).to eq '=Aattribute'
    end

    describe 'when incrementing' do
      before { subject.next(scope) }

      it 'increments within the correct scope' do
        expect(subject.next(scope)).to eq '=Battribute'
      end
    end
  end
end
