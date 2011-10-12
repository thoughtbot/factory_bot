require 'spec_helper'

describe "a built instance" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', :user_id => :integer) do
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

  it "isn't saved" do
    should be_new_record
  end

  it "assigns and saves associations" do
    subject.user.should be_kind_of(User)
    subject.user.should_not be_new_record
  end
end

describe "a built instance with :method => :build" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user

      factory :post do
        association(:user, :method => :build)
      end
    end
  end

  subject { build(:post) }

  it "isn't saved" do
    should be_new_record
  end

  it "assigns but does not save associations" do
    subject.user.should be_kind_of(User)
    subject.user.should be_new_record
  end
end

describe "calling `build` with a block" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', :name => :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the built instance" do
    build(:company, :name => 'thoughtbot') do |company|
      company.name.should eq('thoughtbot')
    end
  end
end
