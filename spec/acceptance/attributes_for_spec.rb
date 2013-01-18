require 'spec_helper'

describe "a generated attributes hash" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')
    define_model('Comment')

    define_model('Post', title:   :string,
                         body:    :string,
                         summary: :string,
                         user_id: :integer) do
      belongs_to :user
      has_many :comments
    end

    FactoryGirl.define do
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

  subject { attributes_for(:post, title: 'overridden title') }

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
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', name: :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the hash of attributes" do
    attributes_for(:company, name: 'thoughtbot') do |attributes|
      expect(attributes[:name]).to eq('thoughtbot')
    end
  end

  it "returns the hash of attributes" do
    expected = nil

    result = attributes_for(:company) do |attributes|
      expected = attributes
      "hello!"
    end
    expect(result).to eq expected
  end
end

describe "`attributes_for` for a class whose constructor has required params" do
  before do
    define_model("User", name: :string) do
      def initialize(arg1, arg2); end
    end

    FactoryGirl.define do
      factory :user do
        name "John Doe"
      end
    end
  end

  subject      { FactoryGirl.attributes_for(:user) }
  its([:name]) { should eq "John Doe" }
end
