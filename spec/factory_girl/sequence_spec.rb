require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject    { FactoryGirl::Sequence.new(name) {|n| "=#{n}" } }

    its(:name)  { should == name }
    its(:names) { should == [name] }
    its(:next)  { should == "=1" }

    describe "when incrementing" do
      before     { subject.next }
      its(:next) { should == "=2" }
    end
  end

  describe "a custom sequence" do
    context "a character sequence" do
      subject    { FactoryGirl::Sequence.new(:name, "A") {|n| "=#{n}" } }
      its(:next) { should == "=A" }

      describe "when incrementing" do
        before     { subject.next }
        its(:next) { should == "=B" }
      end
    end

    context "an array" do
      subject    { FactoryGirl::Sequence.new(:name, ["foo","bar","baz"]) {|n| "=#{n}" } }
      its(:next) { should == "=foo" }

      describe "when incrementing" do
        before     { subject.next }
        its(:next) { should == "=bar" }
      end
    end

    context "an enumerator" do
      subject    { FactoryGirl::Sequence.new(:name, (0..30).step(10)) {|n| "=#{n}" } }
      its(:next) { should == "=0" }

      describe "when incrementing" do
        before     { subject.next }
        its(:next) { should == "=10" }
      end
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
    context "a character sequence" do
      subject    { FactoryGirl::Sequence.new(:name, "A") }
      its(:next) { should == "A" }

      describe "when incrementing" do
        before     { subject.next }
        its(:next) { should == "B" }
      end
    end

    context "an array" do
      subject    { FactoryGirl::Sequence.new(:name, ["foo","bar","baz"]) }
      its(:next) { should == "foo" }

      describe "when incrementing" do
        before     { subject.next }
        its(:next) { should == "bar" }
      end
    end

    context "an enumerator" do
      subject    { FactoryGirl::Sequence.new(:name, (0..30).step(10)) }
      its(:next) { should == 0 }

      describe "when incrementing" do
        before     { subject.next }
        its(:next) { should == 10 }
      end
    end
  end
end
