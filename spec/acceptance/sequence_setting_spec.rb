describe "FactoryBot.set_sequence" do
  include FactoryBot::Syntax::Methods

  # ======================================================================
  # = On Success
  # ======================================================================

  describe "on success" do
    ##
    # = sets correct value
    # ======================================================================
    #
    describe "it sets the sequence to the correct value" do
      it "for an Integer sequence" do
        FactoryBot.define do
          sequence(:email) { |n| "somebody#{n}@example.com" }
        end

        expect(generate_list(:email, 3).last).to eq "somebody3@example.com"
        FactoryBot.set_sequence(:email, 54321)
        expect(generate_list(:email, 3).last).to eq "somebody54323@example.com"
      end

      it "for a negative Integer sequence" do
        FactoryBot.define do
          sequence(:email, -50) { |n| "somebody#{n}@example.com" }
        end

        expect(generate_list(:email, 3).last).to eq "somebody-48@example.com"
        FactoryBot.set_sequence(:email, -25)
        expect(generate_list(:email, 3).last).to eq "somebody-23@example.com"
      end

      it "for an Enumerable sequence" do
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

      it "for a String sequence" do
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

      it "for a Date sequence" do
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

      it "without colliding with other factory or global sequences" do
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
    end # "it sets the sequence to the correct value"

    ##
    # = sets correct sequence
    # ======================================================================
    #
    context "it sets the correct sequence" do
      before(:each) do
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

      it "with a Symbolic URI" do
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

      it "with a String URI" do
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
    end # it sets the correct sequence

    ##
    # = Sequence/Factory Names
    # ======================================================================
    #

    it "it accepts a String or Symbol sequence name" do
      FactoryBot.define do
        sequence(:email) { |n| "user#{n}@example.com" }
      end

      FactoryBot.set_sequence(:email, 54321)
      expect(generate(:email)).to eq "user54321@example.com"

      FactoryBot.set_sequence("email", 777)
      expect(generate(:email)).to eq "user777@example.com"
    end

    it "it accepts a String or Symbol factory name" do
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

    ##
    # = Aliases
    # ======================================================================
    #

    it "succeeds with aliases for both sequence and factory" do
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
  end # "on success"

  # ======================================================================
  # = On Failure
  # ======================================================================
  #
  describe "on failure" do
    # = with an unknown sequence
    # ======================================================================
    #
    context "with an unknown sequence name" do
      it "it fails with an unknown global sequence" do
        expect { FactoryBot.set_sequence(:test, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'test'/
      end

      it "it fails with an unknown factory sequence" do
        FactoryBot.define do
          factory :user do
            sequence(:email) { |n| "alt_user#{n}@example.com" }
          end
        end

        expect { FactoryBot.set_sequence(:user, :test, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'user\/test'/
      end

      it "it fails with an unknown factory sequence but a matching global sequence" do
        FactoryBot.define do
          sequence(:email) { |n| "global#{n}@example.com" }

          factory :user do
            sequence(:alt_email) { |n| "alt_user#{n}@example.com" }
          end
        end

        expect { FactoryBot.set_sequence(:user, :email, 54321) }
          .to raise_error KeyError, /Sequence not registered: 'user\/email'/
      end

      it "it fails with an inherited sequence" do
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
    end # "with an unknown sequence name"

    # = with an Integer sequence
    # ======================================================================
    #
    context "with an Integer sequence" do
      it "it fails with a value lower than the inital value" do
        FactoryBot.define do
          sequence(:counter, 1000)
        end

        expect { FactoryBot.set_sequence(:counter, 999) }
          .to raise_error ArgumentError, /Value cannot be less than: 1000/
      end
    end # "with an Integer sequence"

    ##
    # = value not found
    # ======================================================================
    #
    context "when the value is not found" do
      it "fails with an unmatched String value" do
        FactoryBot.define do
          sequence(:char, "c")
        end

        expect { FactoryBot.set_sequence(:char, "a") }
          .to raise_error ArgumentError, /Unable to find 'a' in the sequence/
      end

      it "fails with an unmatched Enumerable value" do
        names = %w[Jane Joe Josh Jayde John].to_enum

        allow(names).to receive(:next).and_raise(StopIteration)
        allow_any_instance_of(FactoryBot::Sequence).to receive(:can_set_value_by_index?).and_return(false)

        FactoryBot.define do
          sequence(:name, names)
        end

        expect { FactoryBot.set_sequence(:name, "Jester") }
          .to raise_error ArgumentError, /Unable to find 'Jester' in the sequence/
      end

      it "fails if not found within 3 seconds" do
        allow(FactoryBot::Sequence).to receive(:sequence_setting_timeout).and_return(3)

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

      it "leaves the sequence unchanged" do
        FactoryBot.define do
          sequence(:name, %w[Jane Joe Josh Jayde John].to_enum)
        end

        generate_list :name, 2
        expect(generate(:name)).to eq "Josh"

        expect { FactoryBot.set_sequence(:name, "Jester") }
          .to raise_error ArgumentError, /Unable to find 'Jester' in the sequence/

        expect(generate(:name)).to eq "Jayde"
      end
    end # value not found
  end # "On Failure"
end
