describe "FactoryBot.set_sequence" do
  include FactoryBot::Syntax::Methods

  describe "on success" do
    describe "setting sequence to correct value" do
      it "works with Integer sequences" do
        FactoryBot.define do
          sequence(:email) { |n| "somebody#{n}@example.com" }
        end

        expect(generate_list(:email, 3).last).to eq "somebody3@example.com"
        FactoryBot.set_sequence(:email, 54321)
        expect(generate_list(:email, 3).last).to eq "somebody54323@example.com"
      end

      it "works with negative Integer sequences" do
        FactoryBot.define do
          sequence(:email, -50) { |n| "somebody#{n}@example.com" }
        end

        expect(generate_list(:email, 3).last).to eq "somebody-48@example.com"
        FactoryBot.set_sequence(:email, -25)
        expect(generate_list(:email, 3).last).to eq "somebody-23@example.com"
      end

      it "works with Enumerable sequences" do
        define_class("User") { attr_accessor :name }

        FactoryBot.define do
          factory :user do
            sequence(:name, %w[Jane Joe Josh Jayde John].to_enum)
          end
        end

        expect(generate(:user, :name)).to eq "Jane"
        FactoryBot.set_sequence(:user, :name, "Jayde")
        expect(generate(:user, :name)).to eq "Jayde"
        expect(generate(:user, :name)).to eq "John"
      end

      it "works with String sequences" do
        define_class("User") { attr_accessor :initial }

        FactoryBot.define do
          factory :user do
            factory :pilot do
              sequence(:initial, "a")
            end
          end
        end

        expect(generate_list(:pilot, :initial, 3)).to eq ["a", "b", "c"]
        FactoryBot.set_sequence(:pilot, :initial, "z")
        expect(generate_list(:pilot, :initial, 3)).to eq ["z", "aa", "ab"]
      end

      it "works with Date sequences" do
        define_class("User") { attr_accessor :dob }

        FactoryBot.define do
          factory :user do
            factory :pilot do
              factory :jet_pilot do
                sequence(:dob, Date.parse("2025-04-01"))
              end
            end
          end
        end

        expect(generate(:jet_pilot, :dob)).to eq Date.parse("2025-04-01")
        FactoryBot.set_sequence(:jet_pilot, :dob, Date.parse("2025-05-01"))
        expect(generate_list(:jet_pilot, :dob, 3).last).to eq Date.parse("2025-05-03")
      end

      it "works with lazy Integer sequences" do
        FactoryBot.define do
          sequence(:email, proc { 42 }) { |n| "somebody#{n}@example.com" }
        end

        expect(generate_list(:email, 3).last).to eq "somebody44@example.com"
        FactoryBot.set_sequence(:email, 54321)
        expect(generate_list(:email, 3).last).to eq "somebody54323@example.com"
      end

      it "does not collide with other factory or global sequences" do
        define_class("User") { attr_accessor :email }
        define_class("Admin") { attr_accessor :email }

        FactoryBot.define do
          sequence(:email) { |n| "global#{n}@example.com" }
          factory :user do
            sequence(:email) { |n| "user#{n}@example.com" }

            factory :admin do
              sequence(:email) { |n| "admin#{n}@example.com" }
            end
          end
        end

        generate_list :email, 2
        generate_list :user, :email, 2
        generate_list :admin, :email, 2

        expect(generate(:email)).to eq "global3@example.com"
        expect(generate(:user, :email)).to eq "user3@example.com"
        expect(generate(:admin, :email)).to eq "admin3@example.com"

        FactoryBot.set_sequence(:user, :email, 22222)
        FactoryBot.set_sequence(:admin, :email, 33333)

        expect(generate(:email)).to eq "global4@example.com"
        expect(generate(:user, :email)).to eq "user22222@example.com"
        expect(generate(:admin, :email)).to eq "admin33333@example.com"
      end
    end

    describe "sequence targeting by URI" do
      before do
        define_class("User")

        FactoryBot.define do
          sequence :counter

          trait :global_trait do
            sequence :counter
          end

          factory :parent, class: "User" do
            sequence :counter

            trait :parent_trait do
              sequence :counter
            end

            factory :child do
              sequence :counter

              trait :child_trait do
                sequence :counter
              end
            end
          end
        end
      end

      it "accepts symbolic URIs" do
        expect(generate(:counter)).to eq 1
        expect(generate(:global_trait, :counter)).to eq 1
        expect(generate(:parent, :counter)).to eq 1
        expect(generate(:parent, :parent_trait, :counter)).to eq 1
        expect(generate(:child, :counter)).to eq 1
        expect(generate(:child, :child_trait, :counter)).to eq 1

        FactoryBot.set_sequence :counter, 1000
        FactoryBot.set_sequence :global_trait, :counter, 3000
        FactoryBot.set_sequence :parent, :counter, 6000
        FactoryBot.set_sequence :parent, :parent_trait, :counter, 9000
        FactoryBot.set_sequence :child, :counter, 12_000
        FactoryBot.set_sequence :child, :child_trait, :counter, 15_000

        expect(generate(:counter)).to eq 1000
        expect(generate(:global_trait, :counter)).to eq 3000
        expect(generate(:parent, :counter)).to eq 6000
        expect(generate(:parent, :parent_trait, :counter)).to eq 9000
        expect(generate(:child, :counter)).to eq 12_000
        expect(generate(:child, :child_trait, :counter)).to eq 15_000
      end

      it "accepts string URIs" do
        expect(generate("counter")).to eq 1
        expect(generate("global_trait/counter")).to eq 1
        expect(generate("parent/counter")).to eq 1
        expect(generate("parent/parent_trait/counter")).to eq 1
        expect(generate("child/counter")).to eq 1
        expect(generate("child/child_trait/counter")).to eq 1

        FactoryBot.set_sequence "counter", 1000
        FactoryBot.set_sequence "global_trait/counter", 3000
        FactoryBot.set_sequence "parent/counter", 6000
        FactoryBot.set_sequence "parent/parent_trait/counter", 9000
        FactoryBot.set_sequence "child/counter", 12_000
        FactoryBot.set_sequence "child/child_trait/counter", 15_000

        expect(generate("counter")).to eq 1000
        expect(generate("global_trait/counter")).to eq 3000
        expect(generate("parent/counter")).to eq 6000
        expect(generate("parent/parent_trait/counter")).to eq 9000
        expect(generate("child/counter")).to eq 12_000
        expect(generate("child/child_trait/counter")).to eq 15_000
      end
    end

    describe "name format support" do
      it "accepts String or Symbol sequence names" do
        FactoryBot.define do
          sequence(:email) { |n| "user#{n}@example.com" }
        end

        FactoryBot.set_sequence(:email, 54321)
        expect(generate(:email)).to eq "user54321@example.com"

        FactoryBot.set_sequence("email", 777)
        expect(generate(:email)).to eq "user777@example.com"
      end

      it "accepts String or Symbol factory names" do
        define_class("User") { attr_accessor :email }

        FactoryBot.define do
          factory :user do
            sequence(:email) { |n| "user#{n}@example.com" }
          end
        end

        FactoryBot.set_sequence(:user, :email, 54321)
        expect(generate(:user, :email)).to eq "user54321@example.com"

        FactoryBot.set_sequence("user", "email", 777)
        expect(generate("user", "email")).to eq "user777@example.com"
      end
    end

    describe "alias support" do
      it "works with aliases for both sequence and factory" do
        define_class("User") { attr_accessor :email }

        FactoryBot.define do
          factory :user, aliases: [:author, :commenter] do
            sequence(:email, aliases: ["primary_email", :alt_email]) { |n| "user#{n}@example.com" }
          end
        end

        generate_list :user, :email, 2
        expect(generate(:user, :email)).to eq "user3@example.com"

        FactoryBot.set_sequence(:user, :email, 11111)
        expect(generate(:user, :email)).to eq "user11111@example.com"

        FactoryBot.set_sequence(:author, :primary_email, 22222)
        expect(generate(:user, :email)).to eq "user22222@example.com"

        FactoryBot.set_sequence(:commenter, :alt_email, 33333)
        expect(generate(:user, :email)).to eq "user33333@example.com"
      end
    end
  end

  describe "error handling" do
    describe "unknown sequence names" do
      it "raises an error for unknown global sequences" do
        expect { FactoryBot.set_sequence(:test, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'test'/
      end

      it "raises an error for unknown factory sequences" do
        FactoryBot.define do
          factory :user do
            sequence(:email) { |n| "alt_user#{n}@example.com" }
          end
        end

        expect { FactoryBot.set_sequence(:user, :test, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'user\/test'/
      end

      it "raises an error when factory sequence doesn't exist but global does" do
        FactoryBot.define do
          sequence(:email) { |n| "global#{n}@example.com" }

          factory :user do
            sequence(:alt_email) { |n| "alt_user#{n}@example.com" }
          end
        end

        expect { FactoryBot.set_sequence(:user, :email, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'user\/email'/
      end

      it "raises an error for inherited sequences" do
        define_class("User") { attr_accessor :email }

        FactoryBot.define do
          sequence(:email) { |n| "global#{n}@example.com" }

          factory :user do
            sequence(:email) { |n| "user#{n}@example.com" }
            factory :admin
          end
        end

        admin = build(:admin)
        expect(admin.email).to eq "user1@example.com"

        expect { FactoryBot.set_sequence(:admin, :email, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'admin\/email'/
      end
    end

    describe "invalid values" do
      it "raises an error when value is below minimum for Integer sequences" do
        FactoryBot.define do
          sequence(:counter, 1000)
        end

        expect { FactoryBot.set_sequence(:counter, 999) }
          .to raise_error ArgumentError, /Value cannot be less than: 1000/
      end

      it "raises an error for unmatched String values" do
        FactoryBot.define do
          sequence(:char, "c")
        end

        expect { FactoryBot.set_sequence(:char, "a") }
          .to raise_error ArgumentError, /Unable to find 'a' in the sequence/
      end

      it "raises an error for unmatched Enumerable values" do
        names = %w[Jane Joe Josh Jayde John].to_enum

        allow_any_instance_of(FactoryBot::Sequence).to receive(:can_set_value_by_index?).and_return(false)

        FactoryBot.define do
          sequence(:name, names)
        end

        expect { FactoryBot.set_sequence(:name, "Jester") }
          .to raise_error ArgumentError, /Unable to find 'Jester' in the sequence/
      end

      it "times out when value cannot be found within timeout period" do
        with_temporary_assignment(FactoryBot, :sequence_setting_timeout, 3) do
          FactoryBot.define do
            sequence(:test, "a")
          end

          start = Time.now
          expect { FactoryBot.set_sequence(:test, "zzzzzzzzzz") }
            .to raise_error ArgumentError, /Unable to find 'zzzzzzzzzz' in the sequence/

          duration = Time.now - start
          expect(duration >= 3.seconds).to be_truthy
          expect(duration < 4.seconds).to be_truthy
        end
      end

      it "leaves sequence unchanged when value is not found" do
        FactoryBot.define do
          sequence(:name, %w[Jane Joe Josh Jayde John].to_enum)
        end

        generate_list :name, 2
        expect(generate(:name)).to eq "Josh"

        expect { FactoryBot.set_sequence(:name, "Jester") }
          .to raise_error ArgumentError, /Unable to find 'Jester' in the sequence/

        expect(generate(:name)).to eq "Jayde"
      end
    end
  end
end
