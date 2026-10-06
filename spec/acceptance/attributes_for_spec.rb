if RUBY_ENGINE != "truffleruby"
  require_relative "attributes_for_destructuring"
end

describe "a generated attributes hash" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User")
    define_model("Comment")

    define_model("Post", title: :string,
      body: :string,
      summary: :string,
      user_id: :integer) do
      belongs_to :user
      has_many :comments
    end

    FactoryBot.define do
      factory :user
      factory :comment

      factory :post do
        title { "default title" }
        body { "default body" }
        summary { title }
        user
        comments do |c|
          [c.association(:comment)]
        end
      end
    end
  end

  subject { attributes_for(:post, title: "overridden title") }

  it "assigns an overridden value" do
    expect(subject[:title]).to eq "overridden title"
  end

  it "assigns a default value" do
    expect(subject[:body]).to eq "default body"
  end

  it "assigns a lazy, dependent attribute" do
    expect(subject[:summary]).to eq "overridden title"
  end

  it "doesn't assign associations" do
    expect(subject).not_to have_key(:user_id)
    expect(subject).not_to have_key(:user)
  end
end

describe "calling `attributes_for` with a block" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("Company", name: :string)

    FactoryBot.define do
      factory :company
    end
  end

  it "passes the hash of attributes" do
    attributes_for(:company, name: "thoughtbot") do |attributes|
      expect(attributes[:name]).to eq("thoughtbot")
    end
  end

  it "returns the hash of attributes" do
    expected = nil

    result = attributes_for(:company) { |attributes|
      expected = attributes
      "hello!"
    }
    expect(result).to eq expected
  end
end

describe "`attributes_for` for a class whose constructor has required params" do
  before do
    define_model("User", name: :string) do
      def initialize(arg1, arg2)
        # Constructor requesting params to be used for testing
      end
    end

    FactoryBot.define do
      factory :user do
        name { "John Doe" }
      end
    end
  end

  subject { FactoryBot.attributes_for(:user) }
  its([:name]) { should eq "John Doe" }
end

describe "attributes_for with an association replaced by a child factory" do
  before do
    define_model("User", name: :string)
    define_model("Post", title: :string, user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
      factory :user do
        name { "John" }
      end

      factory :post do
        title { "Title" }
        user

        factory :post_with_plain_user do
          user { "not an association" }
        end

        trait :plain_user do
          user { "not an association" }
        end
      end
    end
  end

  it "leaves the attribute out when a child factory redefines it" do
    expect(FactoryBot.attributes_for(:post_with_plain_user)).to eq(title: "Title")
  end

  it "leaves the attribute out when a trait redefines it" do
    expect(FactoryBot.attributes_for(:post, :plain_user)).to eq(title: "Title")
  end
end
