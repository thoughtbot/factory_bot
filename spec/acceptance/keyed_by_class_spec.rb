require 'spec_helper'

describe 'finding factories keyed by class instead of symbol' do
  before do
    define_model("User") do
      attr_accessor :name, :email
    end

    FactoryGirl.define do
      factory :user do
        name 'John Doe'
        sequence(:email) { |n| "person#{n}@example.com" }
      end
    end
  end

  it 'allows interaction based on class name' do
    user = FactoryGirl.create User, email: 'person@example.com'
    expect(user.email).to eq 'person@example.com'
    expect(user.name).to eq 'John Doe'
  end
end
