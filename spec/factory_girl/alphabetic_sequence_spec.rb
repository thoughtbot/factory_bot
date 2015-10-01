require 'spec_helper'

describe FactoryGirl::AlphabeticSequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject    { described_class.new(name) { |n| "=#{n}" } }

    its(:name)  { should eq name }
    its(:names) { should eq [name] }
    its(:next)  { should eq "=000000000000" }
    describe "when incrementing" do
      before { subject.next }
      its(:next) { should eq "=000000000001" }
    end
  end

  describe "a custom sequence" do
    subject    { described_class.new(:name, "0") { |n| "=#{n}" } }
    its(:next) { should eq "=0" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=1" }
    end

    describe "when incrementing into a new length" do
      it "raises an error" do
        expect { 10.times { subject.next } }.to raise_error(FactoryGirl::SequenceOverflowError)
      end
    end
  end

  describe "a basic sequence without a block" do
    subject    { described_class.new(:name) }
    its(:next) { should eq("000000000000") }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "000000000001" }
    end
  end

  describe "a custom sequence without a block" do
    subject { described_class.new(:name, "A") }
    its(:next) { should eq "A" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "B" }
    end

    describe "when incrementing into a new length" do
      it "raises an error" do
        expect { 26.times { subject.next } }.to raise_error(FactoryGirl::SequenceOverflowError)
      end
    end
  end
end
