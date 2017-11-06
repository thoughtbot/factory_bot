require "spec_helper"

describe "FactoryBot.rewind_sequences" do
  include FactoryBot::Syntax::Methods

  before do
    define_model('User', age: :integer)
    FactoryBot.define do
      factory :user do
        sequence(:id)
        sequence(:age)
      end
    end
  end

  it "resets all sequences back to their starting values" do
    FactoryBot.define do
      sequence(:email) { |n| "somebody#{n}@example.com" }
      sequence(:name, %w[Joe Josh].to_enum)
    end

    2.times do
      generate(:email)
      generate(:name)
    end

    FactoryBot.rewind_sequences

    email = generate(:email)
    name = generate(:name)

    expect(email).to eq "somebody1@example.com"
    expect(name).to eq "Joe"
  end

  it "resets all sequences back to their starting values for factory specific sequences" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)

    expect(user1.id).to eq 1
    expect(user1.age).to eq 1

    expect(user2.id).to eq 2
    expect(user2.age).to eq 2

    User.destroy_all
    FactoryBot.rewind_sequences

    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    user3 = FactoryBot.create(:user)

    expect(user1.id).to eq 1
    expect(user1.age).to eq 1

    expect(user2.id).to eq 2
    expect(user2.age).to eq 2

    expect(user3.id).to eq 3
    expect(user3.age).to eq 3
  end
end