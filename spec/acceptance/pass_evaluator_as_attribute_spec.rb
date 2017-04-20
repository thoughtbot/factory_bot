require "spec_helper"

describe "when passing evaluator as attribute" do
  before do
    define_model("Comment", title: :string, post_id: :integer) do
      belongs_to :post
    end
    define_model("Post", title: :string, user_id: :integer) do
      has_many :comments
      belongs_to :user
    end
    define_model("User", name: :string) { has_many :posts }

    FactoryGirl.define do
      factory(:comment) do
        post { build(:post, comments: [self]) }
        title { "re: #{post.title}" }
      end

      factory(:post) do
        user { build :user, posts: [self] }
        comments { build_list(:comment, 1, post: self) }
        title { "Through #{user.name}'s Looking Glass" }
      end

      factory(:user) do
        name "Macguffin"
        posts { build_list(:post, 1, user: self) }
      end
    end
  end

  it "will save the instance" do
    FactoryGirl.create(:user)
    expect(Comment.last.title).to eq("re: Through Macguffin's Looking Glass")
  end

  it "saves correctly going the opposite way up the assn chain" do
    FactoryGirl.create(:comment)
    expect(Comment.last.title).to eq("re: Through Macguffin's Looking Glass")
  end
end
