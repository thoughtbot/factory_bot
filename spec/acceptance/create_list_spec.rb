require 'spec_helper'

describe "create multiple instances" do
  before do
    define_model('Post', title: :string, position: :integer)

    FactoryGirl.define do
      factory(:post) do |post|
        post.title "Through the Looking Glass"
        post.position { rand(10**4) }
      end
    end
  end

  context "without default attributes" do
    subject { FactoryGirl.create_list(:post, 20) }

    its(:length) { should eq 20 }

    it "creates all the posts" do
      subject.each do |record|
        expect(record).not_to be_new_record
      end
    end

    it "uses the default factory values" do
      subject.each do |record|
        expect(record.title).to eq "Through the Looking Glass"
      end
    end
  end

  context "with default attributes" do
    subject { FactoryGirl.create_list(:post, 20, title: "The Hunting of the Snark") }

    it "overrides the default values" do
      subject.each do |record|
        expect(record.title).to eq "The Hunting of the Snark"
      end
    end
  end

  context "with a block" do
    subject do
      FactoryGirl.create_list(:post, 20, title: "The Listing of the Block") do |post|
        post.position = post.id
      end
    end

    it "uses the new values" do
      subject.each_with_index do |record, index|
        expect(record.position).to eq record.id
      end
    end
  end
end

describe "multiple creates and transient attributes to dynamically build attribute lists" do
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
          transient do
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
    expect(FactoryGirl.create(:user_with_posts).posts.length).to eq 5
  end

  it "allows the number of posts to be modified" do
    expect(FactoryGirl.create(:user_with_posts, posts_count: 2).posts.length).to eq 2
  end
end
