require "spec_helper"

describe "syntax methods within dynamic attributes" do
  before do
    define_model("Post", title: :string, user_id: :integer) do
      belongs_to :user

      def generate
        "generate result"
      end
    end
    define_model("User", email: :string)

    FactoryGirl.define do
      sequence(:email_address) {|n| "person-#{n}@example.com" }

      factory :user do
        email { generate(:email_address) }
      end

      factory :post do
        title { generate }
        user { build(:user) }
      end
    end
  end

  it "can access syntax methods from dynamic attributes" do
    FactoryGirl.build(:user).email.should == "person-1@example.com"
    FactoryGirl.attributes_for(:user)[:email].should == "person-2@example.com"
  end

  it "can access syntax methods from dynamic attributes" do
    FactoryGirl.build(:post).user.should be_instance_of(User)
  end

  it "can access methods already existing on the class" do
    FactoryGirl.build(:post).title.should == "generate result"
    FactoryGirl.attributes_for(:post)[:title].should be_nil
  end
end
