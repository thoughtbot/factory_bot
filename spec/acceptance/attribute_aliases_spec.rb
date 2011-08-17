require 'spec_helper'

describe "attribute aliases" do
  before do
    define_model('User', :name => :string, :age => :integer)

    define_model('Post', :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user do
        factory :user_with_name do
          name "John Doe"
        end
      end

      factory :post do
        user
      end

      factory :post_with_named_user, :class => Post do
        user :factory => :user_with_name, :age => 20
      end
    end
  end

  context "assigning an association by foreign key" do
    subject { FactoryGirl.build(:post, :user_id => 1) }

    it "doesn't assign both an association and its foreign key" do
      subject.user_id.should == 1
    end
  end

  context "assigning an association by passing factory" do
    subject { FactoryGirl.create(:post_with_named_user).user }

    it "assigns attributes correctly" do
      subject.name.should == "John Doe"
      subject.age.should == 20
    end
  end
end

