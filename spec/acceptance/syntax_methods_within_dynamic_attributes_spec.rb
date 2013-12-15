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
      sequence(:email_address) { |n| "person-#{n}@example.com" }

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
    expect(FactoryGirl.build(:user).email).to eq "person-1@example.com"
    expect(FactoryGirl.attributes_for(:user)[:email]).to eq "person-2@example.com"
  end

  it "can access syntax methods from dynamic attributes" do
    expect(FactoryGirl.build(:post).user).to be_instance_of(User)
  end

  it "can access methods already existing on the class" do
    expect(FactoryGirl.build(:post).title).to eq "generate result"
    expect(FactoryGirl.attributes_for(:post)[:title]).to be_nil
  end

  it 'allows syntax methods to be used when the block has an arity of 1' do
    FactoryGirl.define do
      factory :post_using_block_with_variable, parent: :post do
        user { |_| build(:user) }
      end
    end

    expect(FactoryGirl.build(:post_using_block_with_variable).user).to be_instance_of(User)
  end
end
