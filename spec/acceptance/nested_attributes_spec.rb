describe "association assignment from nested attributes" do
  before do
    define_model("Post", title: :string) do
      has_many :comments
      accepts_nested_attributes_for :comments
    end

    define_model("Comment", post_id: :integer, body: :text) do
      belongs_to :post
    end

    FactoryBot.define do
      factory :post do
        comments_attributes { [FactoryBot.attributes_for(:comment), FactoryBot.attributes_for(:comment)] }
      end

      factory :comment do
        sequence(:body) { |n| "Body #{n}" }
      end
    end
  end

  it "assigns the correct amount of comments" do
    expect(FactoryBot.create(:post).comments.count).to eq 2
  end

  it "assigns the correct amount of comments when overridden" do
    post = FactoryBot.create(:post, comments_attributes: [FactoryBot.attributes_for(:comment)])

    expect(post.comments.count).to eq 1
  end
end
