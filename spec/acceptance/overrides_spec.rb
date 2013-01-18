require 'spec_helper'

describe "attribute overrides" do
  before do
    define_model('User', admin:   :boolean)
    define_model('Post', title:   :string,
                         secure:  :boolean,
                         user_id: :integer) do
      belongs_to :user

      def secure=(value)
        return unless user && user.admin?
        write_attribute(:secure, value)
      end
    end

    FactoryGirl.define do
      factory :user do
        factory :admin do
          admin true
        end
      end

      factory :post do
        user
        title "default title"
      end
    end
  end

  let(:admin) { FactoryGirl.create(:admin) }

  let(:post_attributes) do
    { secure: false }
  end

  let(:non_admin_post_attributes) do
    post_attributes[:user] = FactoryGirl.create(:user)
    post_attributes
  end

  let(:admin_post_attributes) do
    post_attributes[:user] = admin
    post_attributes
  end

  context "with an admin posting" do
    subject      { FactoryGirl.create(:post, admin_post_attributes) }
    its(:secure) { should eq false }
  end

  context "with a non-admin posting" do
    subject      { FactoryGirl.create(:post, non_admin_post_attributes) }
    its(:secure) { should be_nil }
  end

  context "with no user posting" do
    subject      { FactoryGirl.create(:post, post_attributes) }
    its(:secure) { should be_nil }
  end
end
