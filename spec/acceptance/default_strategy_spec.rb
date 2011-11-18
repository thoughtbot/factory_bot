require 'spec_helper'

describe "default strategy" do
  it "uses create when not specified" do
    define_model('User')

    FactoryWoman.define do
      factory :user
    end

    Factory(:user).should_not be_new_record
  end

  it "can be overridden" do
    define_model('User')

    FactoryWoman.define do
      factory :user, :default_strategy => :build
    end

    Factory(:user).should be_new_record
  end
end

