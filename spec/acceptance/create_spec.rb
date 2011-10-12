require 'spec_helper'

describe "a created instance", :syntax_methods do
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

  subject { create('post') }

  it "saves" do
    should_not be_new_record
  end

  it "assigns and saves associations" do
    subject.user.should be_kind_of(User)
    subject.user.should_not be_new_record
  end
end

describe "a created instance, specifying :method => build", :syntax_methods do
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

  subject { create('post') }

  it "still saves associations (:method => :build only affects build, not create)" do
    subject.user.should be_kind_of(User)
    subject.user.should_not be_new_record
  end
end

describe "a custom create", :syntax_methods do
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
    FactoryGirl.create(:user).should be_persisted
  end
end
