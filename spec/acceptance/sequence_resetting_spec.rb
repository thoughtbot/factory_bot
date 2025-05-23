describe "FactoryBot.rewind_sequences" do
  include FactoryBot::Syntax::Methods

  # ======================================================================
  # = Rewind All Sequences
  # ======================================================================
  #
  describe "for all sequences" do
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

    it "resets sequences within identically named traits" do
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
  end # "for all sequences"

  # ======================================================================
  # = Rewind Named Sequence
  # ======================================================================
  #
  describe "for named sequence" do
    it "resets an individual sequences back to its starting value" do
      define_class("User")

      FactoryBot.define do
        sequence(:email) { |n| "somebody#{n}@example.com" }
        sequence(:name, %w[Jane Joe Jayde Josh].to_enum)

        factory :user do
          sequence :counter

          factory :author do
            sequence :counter
          end
        end
      end

      generate_list(:email, 2)
      generate_list(:name, 2)
      generate_list(:user, :counter, 2)
      generate_list(:author, :counter, 2)

      expect(generate(:email)).to eq "somebody3@example.com"
      expect(generate(:name)).to eq "Jayde"
      expect(generate(:user, :counter)).to eq 3
      expect(generate(:author, :counter)).to eq 3

      FactoryBot.rewind_sequence(:email)
      FactoryBot.rewind_sequence(:author, :counter)

      expect(generate(:email)).to eq "somebody1@example.com"
      expect(generate(:name)).to eq "Josh"
      expect(generate(:user, :counter)).to eq 4
      expect(generate(:author, :counter)).to eq 1
    end

    it "does not collide with globally registered factories" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence(:email) { |n| "global-somebody#{n}@example.com" }

        factory :user do
          sequence(:email) { |n| "local-somebody#{n}@example.com" }
        end
      end

      generate_list(:email, 2)
      generate_list(:user, :email, 2)

      expect(generate(:user, :email)).to eq "local-somebody3@example.com"
      expect(generate(:email)).to eq "global-somebody3@example.com"

      FactoryBot.rewind_sequence :user, :email

      expect(generate(:user, :email)).to eq "local-somebody1@example.com"
      expect(generate(:email)).to eq "global-somebody4@example.com"
    end

    it "still allows global sequences prefixed with a factory name" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence(:user_email) { |n| "global-somebody#{n}@example.com" }

        factory :user do
          sequence(:email) { |n| "local-somebody#{n}@example.com" }
        end
      end

      generate_list(:user_email, 2)
      generate_list(:user, :email, 2)

      expect(generate(:user, :email)).to eq "local-somebody3@example.com"
      expect(generate(:user_email)).to eq "global-somebody3@example.com"

      FactoryBot.rewind_sequence :user, :email

      expect(generate(:user, :email)).to eq "local-somebody1@example.com"
      expect(generate(:user_email)).to eq "global-somebody4@example.com"
    end

    it "does not conflict with identically named traits" do
      define_class("User")
      define_class("Person")

      FactoryBot.define do
        trait :with_counter do
          sequence :counter
        end
        factory :user do
          trait :with_counter do
            sequence :counter
          end
        end

        factory :person do
          trait :with_counter do
            sequence :counter
          end
        end
      end

      generate_list(:with_counter, :counter, 2)
      generate_list(:user, :with_counter, :counter, 2)
      generate_list(:person, :with_counter, :counter, 2)

      expect(generate(:with_counter, :counter)).to eq 3
      expect(generate(:user, :with_counter, :counter)).to eq 3
      expect(generate(:person, :with_counter, :counter)).to eq 3

      FactoryBot.rewind_sequence :user, :with_counter, :counter

      expect(generate(:with_counter, :counter)).to eq 4
      expect(generate(:user, :with_counter, :counter)).to eq 1
      expect(generate(:person, :with_counter, :counter)).to eq 4
    end

    it "it fails with an unknown sequence" do
      expect { FactoryBot.rewind_sequence(:test_sequence) }
        .to raise_error KeyError, /Sequence not registered: 'test_sequence'/

      expect { FactoryBot.rewind_sequence(:user, :test_sequence) }
        .to raise_error KeyError, /Sequence not registered: 'user\/test_sequence'/
    end

    it "it fails with no arguments" do
      expect { FactoryBot.rewind_sequence }
        .to raise_error ArgumentError,
          /wrong number of arguments \(given 0, expected 1\+\)/
    end
  end # "for named sequence"
end
