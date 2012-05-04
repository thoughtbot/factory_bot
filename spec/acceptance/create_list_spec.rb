require 'spec_helper'

describe "create multiple instances" do
  before do
    define_model('Post', title: :string)

    FactoryGirl.define do
      factory(:post) do |post|
        post.title "Through the Looking Glass"
      end
    end
  end

  context "without default attributes" do
    subject { FactoryGirl.create_list(:post, 20) }

    its(:length) { should == 20 }

    it "creates all the posts" do
      subject.each do |record|
        record.should_not be_new_record
      end
    end

    it "uses the default factory values" do
      subject.each do |record|
        record.title.should == "Through the Looking Glass"
      end
    end
  end

  context "with default attributes" do
    subject { FactoryGirl.create_list(:post, 20, title: "The Hunting of the Snark") }

    it "overrides the default values" do
      subject.each do |record|
        record.title.should == "The Hunting of the Snark"
      end
    end
  end
end

describe "multiple creates and ignored attributes to dynamically build attribute lists" do
  before do
    define_model('User', name: :string) do
      has_many :posts
    end

    define_model('Post', title: :string, user_id: :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :post do
        title "Through the Looking Glass"
        user
      end

      factory :user do
        name "John Doe"

        factory :user_with_posts do
          ignore do
            posts_count 5
          end

          after(:create) do |user, evaluator|
            FactoryGirl.create_list(:post, evaluator.posts_count, user: user)
          end
        end
      end
    end
  end

  it "generates the correct number of posts" do
    FactoryGirl.create(:user_with_posts).posts.length.should == 5
  end

  it "allows the number of posts to be modified" do
    FactoryGirl.create(:user_with_posts, posts_count: 2).posts.length.should == 2
  end
end
