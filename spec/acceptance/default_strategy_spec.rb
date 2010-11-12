require 'spec_helper'
require 'acceptance/acceptance_helper'

describe "default strategy" do
  it "uses create when not specified" do
    define_model('User')

    FactoryGirl.define do
      factory :user do
      end
    end

    Factory(:user).should_not be_new_record
  end

  it "can be overridden" do
    define_model('User')

    FactoryGirl.define do
      factory :user, :default_strategy => :build do
      end
    end

    Factory(:user).should be_new_record
  end
end

