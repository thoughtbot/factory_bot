require 'spec_helper'

describe 'global initialize_with' do
  before do
    ActiveSupport::Deprecation.silenced = true

    define_class('User') do
      attr_accessor:name

      def initialize(name)
        @name = name
      end
    end

    define_class('Post') do
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    FactoryGirl.define do
      initialize_with { new("initialize_with") }

      trait :with_initialize_with do
        initialize_with { new("trait initialize_with") }
      end

      factory :user do
        factory :child_user

        factory :child_user_with_trait do
          with_initialize_with
        end
      end

      factory :post do
        factory :child_post

        factory :child_post_with_trait do
          with_initialize_with
        end
      end
    end
  end

  it 'handles base initialize_with' do
    FactoryGirl.build(:user).name.should == 'initialize_with'
    FactoryGirl.build(:post).name.should == 'initialize_with'
  end

  it 'handles child initialize_with' do
    FactoryGirl.build(:child_user).name.should == 'initialize_with'
    FactoryGirl.build(:child_post).name.should == 'initialize_with'
  end

  it 'handles child initialize_with with trait' do
    FactoryGirl.build(:child_user_with_trait).name.should == 'trait initialize_with'
    FactoryGirl.build(:child_post_with_trait).name.should == 'trait initialize_with'
  end

  it 'handles inline trait override' do
    FactoryGirl.build(:child_user, :with_initialize_with).name.should == 'trait initialize_with'
    FactoryGirl.build(:child_post, :with_initialize_with).name.should == 'trait initialize_with'
  end

  it 'uses initialize_with globally across FactoryGirl.define' do
    define_class('Company') do
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    FactoryGirl.define do
      factory :company
    end

    FactoryGirl.build(:company).name.should == 'initialize_with'
    FactoryGirl.build(:company, :with_initialize_with).name.should == 'trait initialize_with'
  end
end
