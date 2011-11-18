require 'spec_helper'

describe "sequences" do
  include FactoryWoman::Syntax::Methods

  it "generates several values in the correct format" do
    FactoryWoman.define do
      sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    first_value = generate(:email)
    another_value = generate(:email)

    first_value.should =~ /^somebody\d+@example\.com$/
    another_value.should =~ /^somebody\d+@example\.com$/
    first_value.should_not == another_value
  end

  it "generates sequential numbers if no block is given" do
    FactoryWoman.define do
      sequence :order
    end

    first_value = generate(:order)
    another_value = generate(:order)

    first_value.should == 1
    another_value.should == 2
    first_value.should_not == another_value
  end
end
