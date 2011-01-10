require 'spec_helper'

describe FactoryGirl::Sequence do
  describe "a basic sequence" do
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
  
  describe "a custom sequence" do
    before do
      @sequence = FactoryGirl::Sequence.new("A") {|n| "=#{n}" }
    end

    it "should start with a value of A" do
      @sequence.next.should == "=A"
    end

    describe "after being called" do
      before do
        @sequence.next
      end

      it "should use the next value" do
        @sequence.next.should == "=B"
      end
    end
  end

  describe "array sequence" do
    before do
      @sequence = FactoryGirl::Sequence.new(%w(one two)) {|ae| "#{ae}gir"}
    end

    it "should start with 'one'" do
      @sequence.next.should == 'onegir'
    end
    
    describe "after being called" do
      before do
        @sequence.next
      end
      
      it "should use the next value" do
        @sequence.next.should == 'twogir'
      end
    end
      
  end
  
  describe "array plus numerical sequence" do
    before do
      @sequence = FactoryGirl::Sequence.new(1, %w(one two)) {|value, array| "#{value}#{array}"}
    end
    
    it "should start with '1one'" do
      @sequence.next.should == '1one'
    end
    
    describe "after being called once" do
      before do
        @sequence.next
      end
      
      it "should use the next value" do
        @sequence.next.should == "2two"
      end
    end
    
    describe "after looping around" do
      it "should be '1one'" do
        @sequence.next.should == '1one'
      end
    end
  end
  
  describe "just a block" do
    before do
      @sequence = FactoryGirl::Sequence.new() {rand(125)}
    end
    
    it "should return a random number" do
      @sequence.next.class.should == Fixnum
    end
  end
end
