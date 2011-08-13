require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject    { FactoryGirl::Sequence.new(name) {|n| "=#{n}" } }

    its(:name)             { should == name }
    its(:names)            { should == [name] }
    its(:next)             { should == "=1" }
    its(:default_strategy) { should == :create }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should == "=2" }
    end
  end

  describe "a custom sequence" do
    subject    { FactoryGirl::Sequence.new(:name, "A") {|n| "=#{n}" } }
    its(:next) { should == "=A" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should == "=B" }
    end
  end

  describe "a basic sequence without a block" do
    subject    { FactoryGirl::Sequence.new(:name) }
    its(:next) { should == 1 }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should == 2 }
    end
  end

  describe "a custom sequence without a block" do
    subject    { FactoryGirl::Sequence.new(:name, "A") }
    its(:next) { should == "A" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should == "B" }
    end
  end
end
