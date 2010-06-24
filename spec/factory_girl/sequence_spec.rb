require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a sequence" do
    before do
      @sequence = FactoryGirl::Sequence.new {|n| "=#{n}" }
    end

    it "should start with a value of 1" do
      @sequence.next.should == "=1"
    end

    describe "after being called" do
      before do
        @sequence.next
      end

      it "should use the next value" do
        @sequence.next.should == "=2"
      end
    end
  end
end
