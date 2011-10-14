require 'spec_helper'

describe "sequences", :syntax_methods do
  it "generates several values in the correct format" do
    FactoryGirl.define do
      sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    first_value = generate(:email)
    another_value = generate(:email)

    first_value.should =~ /^somebody\d+@example\.com$/
    another_value.should =~ /^somebody\d+@example\.com$/
    first_value.should_not eq another_value
  end

  it "generates sequential numbers if no block is given" do
    FactoryGirl.define do
      sequence :order
    end

    first_value = generate(:order)
    another_value = generate(:order)

    first_value.should eq 1
    another_value.should eq 2
    first_value.should_not eq another_value
  end
end
