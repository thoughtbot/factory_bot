require 'spec_helper'

require 'factory_girl/syntax/blueprint'

describe "a blueprint" do
  before do
    ActiveSupport::Deprecation.silenced = true

    define_model('User', first_name: :string, last_name: :string, email: :string)

    FactoryGirl.define do
      sequence(:email) { |n| "somebody#{n}@example.com" }
    end

    User.blueprint do
      first_name { 'Bill'                       }
      last_name  { 'Nye'                        }
      email      { FactoryGirl.generate(:email) }
    end
  end

  describe "after making an instance" do
    before do
      @instance = FactoryGirl.create(:user, last_name: 'Rye')
    end

    it "uses attributes from the blueprint" do
      @instance.first_name.should == 'Bill'
    end

    it "evaluates attribute blocks for each instance" do
      @instance.email.should =~ /somebody\d+@example.com/
      FactoryGirl.create(:user).email.should_not == @instance.email
    end
  end
end
