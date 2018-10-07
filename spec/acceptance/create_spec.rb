describe "a created instance" do
  include FactoryBot::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
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
  include FactoryBot::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
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
  include FactoryBot::Syntax::Methods

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

    FactoryBot.define do
      factory :user do
        to_create(&:persist)
      end
    end
  end

  it "uses the custom create block instead of save" do
    expect(FactoryBot.create(:user)).to be_persisted
  end
end

describe "a custom create passing in an evaluator" do
  before do
    define_class("User") do
      attr_accessor :name
    end

    FactoryBot.define do
      factory :user do
        transient { creation_name { "evaluator" } }

        to_create do |user, evaluator|
          user.name = evaluator.creation_name
        end
      end
    end
  end

  it "passes the evaluator to the custom create block" do
    expect(FactoryBot.create(:user).name).to eq "evaluator"
  end
end

describe "calling `create` with a block" do
  include FactoryBot::Syntax::Methods

  before do
    define_model('Company', name: :string)

    FactoryBot.define do
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
