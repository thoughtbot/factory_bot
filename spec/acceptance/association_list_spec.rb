require 'spec_helper'

describe "association lists to populate has many associations" do
  before do
    define_model('User', :name => :string) do
      has_many :posts
    end

    define_model('Post', :title => :string, :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :post do
        title "Through the Looking Glass"
        user
      end

      factory :user do
        name "John Doe"
        association_list :posts, 5, :user => nil, :title => "Six Little Brooks"
      end
    end
  end

  describe "using the create strategy" do
    it "generates the correct number of posts" do
      FactoryGirl.create(:user).posts.length.should == 5
    end

    it "passes through overrides" do
      FactoryGirl.create(:user).posts.first.title.should == "Six Little Brooks"
    end
  end

  describe "using the build strategy" do
    it "generates the correct number of posts" do
      FactoryGirl.build(:user).posts.length.should == 5
    end

    it "passes through overrides" do
      FactoryGirl.build(:user).posts.first.title.should == "Six Little Brooks"
    end
  end

  describe "using the attributes for strategy" do
    it "creates no posts" do
      FactoryGirl.attributes_for(:user)[:posts].should be_nil
    end
  end
end
