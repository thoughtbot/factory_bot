require 'spec_helper'

describe "alphabetic_sequences" do
  include FactoryGirl::Syntax::Methods

  it "generates several values in the correct format" do
    FactoryGirl.define do
      alphabetic_sequence :email do |n|
        "somebody#{n}@example.com"
      end
    end

    first_value = generate(:email)
    another_value = generate(:email)

    expect(first_value).to match /^somebody\d+@example\.com$/
    expect(another_value).to match /^somebody\d+@example\.com$/
    expect(first_value).not_to eq another_value
  end

  it "errors when the next item in sequence is < the previous" do
    FactoryGirl.define do
      alphabetic_sequence :email, "0" do |n|
        "somebody#{n}@example.com"
      end
    end

    expect { 10.times { generate(:email) } }.to raise_error(FactoryGirl::SequenceOverflowError)
  end
end
