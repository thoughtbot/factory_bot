require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a basic sequence" do
    before do
      @name = :test
      @sequence = FactoryGirl::Sequence.new(@name) {|n| "=#{n}" }
    end

    it "has names" do
      @sequence.names.should == [@name]
    end

    it "should start with a value of 1" do
      @sequence.run.should == "=1"
    end

    it "responds to next" do
      @sequence.next.should == "=1"
    end

    it "responds to default_strategy" do
      @sequence.default_strategy.should == :create
    end

    it "runs compatible with the Factory interface" do
      @sequence.run(nil, nil).should == "=1"
    end

    describe "after being called" do
      before do
        @sequence.run
      end

      it "should use the next value" do
        @sequence.run.should == "=2"
      end
    end
  end

  describe "a custom sequence" do
    before do
      @sequence = FactoryGirl::Sequence.new(:name, "A") {|n| "=#{n}" }
    end

    it "should start with a value of A" do
      @sequence.run.should == "=A"
    end

    describe "after being called" do
      before do
        @sequence.run
      end

      it "should use the next value" do
        @sequence.run.should == "=B"
      end
    end
  end

  describe "a basic sequence without a block" do
    before do
      @sequence = FactoryGirl::Sequence.new(:name)
    end

    it "should start with a value of 1" do
      @sequence.run.should == 1
    end

    describe "after being called" do
      before do
        @sequence.run
      end

      it "should use the next value" do
        @sequence.run.should == 2
      end
    end
  end

  describe "a custom sequence without a block" do
    before do
      @sequence = FactoryGirl::Sequence.new(:name, "A")
    end

    it "should start with a value of A" do
      @sequence.run.should == "A"
    end

    describe "after being called" do
      before do
        @sequence.run
      end

      it "should use the next value" do
        @sequence.run.should == "B"
      end
    end
  end
end
