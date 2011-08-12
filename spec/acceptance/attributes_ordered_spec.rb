require 'spec_helper'

describe "a generated attributes hash where order matters" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('ParentModel', :static           => :integer,
                                :evaluates_first  => :integer,
                                :evaluates_second => :integer,
                                :evaluates_third  => :integer)

    FactoryGirl.define do
      factory :parent_model do
        evaluates_first  { static }
        evaluates_second { evaluates_first }
        evaluates_third  { evaluates_second }

        factory :child_model do
          static 1
        end
      end

      factory :without_parent, :class => ParentModel do
        evaluates_first   { static }
        evaluates_second  { evaluates_first }
        evaluates_third   { evaluates_second }
        static 1
      end
    end
  end

  context "factory with a parent" do
    subject { FactoryGirl.build(:child_model) }

    it "assigns attributes in the order they're defined with preference to static attributes" do
      subject[:evaluates_first].should  == 1
      subject[:evaluates_second].should == 1
      subject[:evaluates_third].should  == 1
    end
  end

  context "factory without a parent" do
    subject { FactoryGirl.build(:without_parent) }

    it "assigns attributes in the order they're defined with preference to static attributes without a parent class" do
      subject[:evaluates_first].should  == 1
      subject[:evaluates_second].should == 1
      subject[:evaluates_third].should  == 1
    end
  end
end
