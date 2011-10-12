require 'spec_helper'

describe "a built instance", :syntax_methods do
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

describe "a built instance with :method => :build", :syntax_methods do
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
