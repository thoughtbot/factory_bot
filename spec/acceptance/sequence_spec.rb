require 'spec_helper'
require 'acceptance/acceptance_helper'

describe "sequences" do
  it "generates several values in the correct format" do
    FactoryGirl.define do
      sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    first_value = Factory.next(:email)
    another_value = Factory.next(:email)

    first_value.should =~ /^somebody\d+@example\.com$/
    another_value.should =~ /^somebody\d+@example\.com$/
    first_value.should_not == another_value
  end
end

