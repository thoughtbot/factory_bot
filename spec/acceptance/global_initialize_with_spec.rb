require 'spec_helper'

describe 'global initialize_with' do
  before do
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
    expect(FactoryGirl.build(:user).name).to eq 'initialize_with'
    expect(FactoryGirl.build(:post).name).to eq 'initialize_with'
  end

  it 'handles child initialize_with' do
    expect(FactoryGirl.build(:child_user).name).to eq 'initialize_with'
    expect(FactoryGirl.build(:child_post).name).to eq 'initialize_with'
  end

  it 'handles child initialize_with with trait' do
    expect(FactoryGirl.build(:child_user_with_trait).name).to eq 'trait initialize_with'
    expect(FactoryGirl.build(:child_post_with_trait).name).to eq 'trait initialize_with'
  end

  it 'handles inline trait override' do
    expect(FactoryGirl.build(:child_user, :with_initialize_with).name).to eq 'trait initialize_with'
    expect(FactoryGirl.build(:child_post, :with_initialize_with).name).to eq 'trait initialize_with'
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

    expect(FactoryGirl.build(:company).name).to eq 'initialize_with'
    expect(FactoryGirl.build(:company, :with_initialize_with).name).to eq 'trait initialize_with'
  end
end
