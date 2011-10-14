require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject    { FactoryGirl::Sequence.new(name) {|n| "=#{n}" } }

    its(:name)             { should eq name }
    its(:names)            { should eq [name] }
    its(:next)             { should eq "=1" }
    its(:default_strategy) { should eq :create }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=2" }
    end
  end

  describe "a custom sequence" do
    subject    { FactoryGirl::Sequence.new(:name, "A") {|n| "=#{n}" } }
    its(:next) { should eq "=A" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should eq "=B" }
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
end
