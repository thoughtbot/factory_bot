require 'spec_helper'

describe "sequences" do
  include FactoryGirl::Syntax::Methods

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
    first_value.should_not == another_value
  end

  it "generates sequential numbers if no block is given" do
    FactoryGirl.define do
      sequence :order
    end

    first_value = generate(:order)
    another_value = generate(:order)

    first_value.should == 1
    another_value.should == 2
    first_value.should_not == another_value
  end

  it "generates aliases for the sequence that reference the same block" do
    FactoryGirl.define do
      sequence(:size, aliases: [:count, :length]) {|n| "called-#{n}" }
    end

    first_value  = generate(:size)
    second_value = generate(:count)
    third_value  = generate(:length)

    first_value.should  == "called-1"
    second_value.should == "called-2"
    third_value.should  == "called-3"
  end

  it "generates aliases for the sequence that reference the same block and retains value" do
    FactoryGirl.define do
      sequence(:size, "a", aliases: [:count, :length]) {|n| "called-#{n}" }
    end

    first_value  = generate(:size)
    second_value = generate(:count)
    third_value  = generate(:length)

    first_value.should  == "called-a"
    second_value.should == "called-b"
    third_value.should  == "called-c"
  end
end
