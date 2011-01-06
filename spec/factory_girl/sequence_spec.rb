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
      @sequence = FactoryGirl::Sequence.new(1, %w(one two)) {|a,n| "#{a}#{n}"}
    end
    
    it "should start with 'one1'" do
      @sequence.next.should == 'one1'
    end
    
    describe "after being called once" do
      before do
        @sequence.next
      end
      
      it "should use the next value" do
        @sequence.next.should == "two2"
      end
    end
  end
end
