describe "FactoryBot.rewind_sequences" do
  include FactoryBot::Syntax::Methods

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

  it "resets inline sequences back to their starting value" do
    define_class("User") { attr_accessor :email }

    FactoryBot.define do
      factory :user do
        sequence(:email) { |n| "somebody#{n}@example.com" }
      end
    end

    build_list(:user, 2)

    FactoryBot.rewind_sequences

    user = build(:user)

    expect(user.email).to eq "somebody1@example.com"
  end

  it "does not collide with globally registered factories" do
    define_class("User") { attr_accessor :email }

    FactoryBot.define do
      sequence(:email) { |n| "global-somebody#{n}@example.com" }

      factory :user do
        sequence(:email) { |n| "local-somebody#{n}@example.com" }
      end
    end

    2.times do
      generate(:email)
    end

    build_list(:user, 2)

    FactoryBot.rewind_sequences

    user = build(:user)
    email = generate(:email)

    expect(user.email).to eq "local-somebody1@example.com"
    expect(email).to eq "global-somebody1@example.com"
  end

  it "still allows global sequences prefixed with a factory name" do
    define_class("User") { attr_accessor :email }

    FactoryBot.define do
      sequence(:user_email) { |n| "global-somebody#{n}@example.com" }

      factory :user do
        sequence(:email) { |n| "local-somebody#{n}@example.com" }
      end
    end

    2.times do
      generate(:user_email)
    end

    build_list(:user, 2)

    FactoryBot.rewind_sequences

    user = build(:user)
    email = generate(:user_email)

    expect(user.email).to eq "local-somebody1@example.com"
    expect(email).to eq "global-somebody1@example.com"
  end

  it "allows setting sequences within identically named traits" do
    define_class("User") { attr_accessor :email }
    define_class("Person") { attr_accessor :email }

    FactoryBot.define do
      factory :user do
        trait :with_email do
          sequence(:email) { |n| "user#{n}@example.com" }
        end
      end

      factory :person do
        trait :with_email do
          sequence(:email) { |n| "person#{n}@example.com" }
        end
      end
    end

    build_list(:user, 2, :with_email)
    build_list(:person, 2, :with_email)

    FactoryBot.rewind_sequences

    user = build(:user, :with_email)
    person = build(:person, :with_email)

    expect(user.email).to eq "user1@example.com"
    expect(person.email).to eq "person1@example.com"
  end
end
