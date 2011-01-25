require 'spec_helper'
require 'acceptance/acceptance_helper'

describe "sequences" do
  it "generates several values in the correct format" do
    FactoryGirl.define do
      sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    first_value = FactoryGirl.create(:email)
    another_value = FactoryGirl.create(:email)

    first_value.should =~ /^somebody\d+@example\.com$/
    another_value.should =~ /^somebody\d+@example\.com$/
    first_value.should_not == another_value
  end

  it "generates sequential numbers if no block is given" do
    FactoryGirl.define do
      sequence :order
    end

    first_value = FactoryGirl.create(:order)
    another_value = FactoryGirl.create(:order)

    first_value.should == 1
    another_value.should == 2
    first_value.should_not == another_value
  end
end
