require "spec_helper"

describe "association assignment from nested attributes" do
  before do
    define_model("Post", title: :string) do
      has_many :comments
      accepts_nested_attributes_for :comments
    end

    define_model("Comment", post_id: :integer, body: :text) do
      belongs_to :post
    end

    FactoryGirl.define do
      factory :post do
        comments_attributes { [FactoryGirl.attributes_for(:comment), FactoryGirl.attributes_for(:comment)] }
      end

      factory :comment do
        sequence(:body) {|n| "Body #{n}" }
      end
    end
  end

  it "assigns the correct amount of comments" do
    expect(FactoryGirl.create(:post).comments.count).to eq 2
  end

  it "assigns the correct amount of comments when overridden" do
    expect(FactoryGirl.create(:post, :comments_attributes => [FactoryGirl.attributes_for(:comment)]).comments.count).to eq 1
  end
end
