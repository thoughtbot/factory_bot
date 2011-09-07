require "spec_helper"

describe "modifying inherited factories with traits" do
  before do
    define_model('User', :gender => :string)
    FactoryGirl.define do
      factory :user do
        trait(:female)     { gender "Female" }
        trait(:male)       { gender "Male" }

        female

        factory :female_user do
          gender "Female"
        end

        factory :male_user do
          gender "Male"
        end
      end
    end
  end

  it "returns the correct value for overridden attributes from traits" do
    pending("Declarations")
    Factory.build(:male_user).gender.should == "Male"
  end
end
