require 'spec_helper'

describe "a stubbed instance" do
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

  subject { build_stubbed(:post) }

  it "acts as if it came from the database" do
    should_not be_new_record
  end

  it "assigns associations and acts as if it is saved" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end

describe "a stubbed instance overriding strategy" do
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

  subject { build_stubbed(:post) }

  it "acts as if it is saved in the database" do
    should_not be_new_record
  end

  it "assigns associations and acts as if it is saved" do
    expect(subject.user).to be_kind_of(User)
    expect(subject.user).not_to be_new_record
  end
end
