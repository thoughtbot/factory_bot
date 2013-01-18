require 'spec_helper'

describe "a built instance" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', user_id: :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user

      factory :post do
        user
      end
    end
  end

  subject { build(:post) }

  it { should be_new_record }

  it "assigns and saves associations" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end

describe "a built instance with strategy: :build" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', user_id: :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user

      factory :post do
        association(:user, strategy: :build)
      end
    end
  end

  subject { build(:post) }

  it { should be_new_record }

  it "assigns but does not save associations" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).to be_new_record
  end
end

describe "calling `build` with a block" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', name: :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the built instance" do
    build(:company, name: 'thoughtbot') do |company|
      expect(company.name).to eq('thoughtbot')
    end
  end

  it "returns the built instance" do
    expected = nil
    result = build(:company) do |company|
      expected = company
      "hello!"
    end
    expect(result).to eq expected
  end
end
