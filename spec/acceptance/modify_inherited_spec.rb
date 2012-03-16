require "spec_helper"

describe "modifying inherited factories with traits" do
  before do
    define_model('User', gender: :string, admin: :boolean, age: :integer)
    FactoryGirl.define do
      factory :user do
        trait(:female) { gender "Female" }
        trait(:male)   { gender "Male" }

        trait(:young_admin) do
          admin true
          age   17
        end

        female
        young_admin

        factory :female_user do
          gender "Female"
          age 25
        end

        factory :male_user do
          gender "Male"
        end
      end
    end
  end

  it "returns the correct value for overridden attributes from traits" do
    FactoryGirl.build(:male_user).gender.should == "Male"
  end

  it "returns the correct value for overridden attributes from traits defining multiple attributes" do
    FactoryGirl.build(:female_user).gender.should == "Female"
    FactoryGirl.build(:female_user).age.should == 25
    FactoryGirl.build(:female_user).admin.should == true
  end

  it "allows modification of attributes created via traits" do
    FactoryGirl.modify do
      factory :male_user do
        age 20
      end
    end

    FactoryGirl.build(:male_user).gender.should == "Male"
    FactoryGirl.build(:male_user).age.should == 20
    FactoryGirl.build(:male_user).admin.should == true
  end
end
