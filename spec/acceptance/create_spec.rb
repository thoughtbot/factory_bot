require 'spec_helper'

describe "a created instance" do
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

  subject { create('post') }

  it { should_not be_new_record }

  it "assigns and saves associations" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end

describe "a created instance, specifying strategy: :build" do
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

  subject { create(:post) }

  it "saves associations (strategy: :build only affects build, not create)" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end

describe "a custom create" do
  include FactoryGirl::Syntax::Methods

  before do
    define_class('User') do
      def initialize
        @persisted = false
      end

      def persist
        @persisted = true
      end

      def persisted?
        @persisted
      end
    end

    FactoryGirl.define do
      factory :user do
        to_create do |user|
          user.persist
        end
      end
    end
  end

  it "uses the custom create block instead of save" do
    expect(FactoryGirl.create(:user)).to be_persisted
  end
end

describe "calling `create` with a block" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', name: :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the created instance" do
    create(:company, name: 'thoughtbot') do |company|
      expect(company.name).to eq('thoughtbot')
    end
  end

  it "returns the created instance" do
    expected = nil
    result = create(:company) do |company|
      expected = company
      "hello!"
    end
    expect(result).to eq expected
  end
end
