require 'spec_helper'
require 'acceptance/acceptance_helper'

describe "a generated attributes hash where order matters" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('ParentModel', :a   => :integer,
                              :b    => :integer,
                              :c => :integer,
                              :d => :integer)

    FactoryGirl.define do
      factory :parent_model do
        b { a }
        c { b }
        d { c }
        
        factory :child_model do
          a 1
        end
      end
    end
  end

  subject { FactoryGirl.build(:child_model) }

  it "assigns attributes in the order they're defined with preference to static attributes" do
    subject[:b].should == 1
    subject[:c].should == 1
    subject[:d].should == 1
  end

end

