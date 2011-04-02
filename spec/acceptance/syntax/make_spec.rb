require 'spec_helper'
require 'acceptance/acceptance_helper'

require 'factory_girl/syntax/make'

describe "a factory using make syntax" do
  before do
    define_model('User', :first_name => :string, :last_name => :string)

    FactoryGirl.define do
      factory :user do
        first_name 'Bill'
        last_name  'Nye'
      end

      factory :hail_to_the_king_baby, :parent => :user do
        first_name 'Duke'
        last_name  'Nukem'
      end
    end
  end

  describe "after make" do
    before do
      @instance = User.make(:last_name => 'Rye')
    end

    it "should use attributes from the factory" do
      @instance.first_name.should == 'Bill'
    end

    it "should use attributes passed to make" do
      @instance.last_name.should == 'Rye'
    end

    it "should save the record" do
      @instance.should be_new_record
    end
  end

  describe "after make!" do
    before do
      @instance = User.make!(:last_name => 'Rye')
    end

    it "should use attributes from the factory" do
      @instance.first_name.should == 'Bill'
    end

    it "should use attributes passed to make" do
      @instance.last_name.should == 'Rye'
    end

    it "should save the record" do
      @instance.should_not be_new_record
    end
  end


  describe "after make with factory key" do
    before do
      @instance = User.make(:hail_to_the_king_baby, :last_name => 'Rye')
    end

    it "should use attributes from the factory" do
      @instance.first_name.should == 'Duke'
    end

    it "should use attributes passed to make" do
      @instance.last_name.should == 'Rye'
    end

    it "should save the record" do
      @instance.should be_new_record
    end
  end


end
