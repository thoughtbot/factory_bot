describe "associations" do
  context "when accidentally using an implicit delcaration for the factory" do
    it "raises an error" do
      define_class("Post")

      FactoryBot.define do
        factory :post do
          author factory: user
        end
      end

      expect { FactoryBot.build(:post) }.to raise_error(
        ArgumentError,
        "Association 'author' received an invalid factory argument.\n" \
        "Did you mean? 'factory: :user'\n"
      )
    end
  end

  context "when accidentally using an implicit delcaration as an override" do
    it "raises an error" do
      define_class("Post")

      FactoryBot.define do
        factory :post do
          author factory: :user, invalid_attribute: implicit_trait
        end
      end

      expect { FactoryBot.build(:post) }.to raise_error(
        ArgumentError,
        "Association 'author' received an invalid attribute override.\n" \
        "Did you mean? 'invalid_attribute: :implicit_trait'\n"
      )
    end
  end

  context "when building interrelated associations" do
    it "assigns the instance passed as an association attribute" do
      define_class("Supplier") do
        attr_accessor :account
      end

      define_class("Account") do
        attr_accessor :supplier
      end

      FactoryBot.define do
        factory :supplier

        factory :account do
          supplier { association(:supplier, account: instance) }
        end
      end

      account = FactoryBot.build(:account)

      expect(account.supplier.account).to eq(account)
    end

    it "connects records with interdependent relationships" do
      define_model("User", school_id: :integer) do
        belongs_to :school
        has_one :profile
      end

      define_model("Profile", school_id: :integer, user_id: :integer) do
        belongs_to :school
        belongs_to :user
      end

      define_model("School") do
        has_many :users
        has_many :profiles
      end

      FactoryBot.define do
        factory :user do
          school
          profile { association :profile, user: instance, school: school }
        end

        factory :profile do
          school
          user { association :user, profile: instance, school: school }
        end

        factory :school
      end

      user = FactoryBot.create(:user)

      expect(user.profile.school).to eq(user.school)
      expect(user.profile.user).to eq(user)
      expect(user.school.users.map(&:id)).to eq([user.id])
      expect(user.school.profiles.map(&:id)).to eq([user.profile.id])

      profile = FactoryBot.create(:profile)

      expect(profile.user.school).to eq(profile.school)
      expect(profile.user.profile).to eq(profile)
      expect(profile.school.profiles.map(&:id)).to eq([profile.id])
      expect(profile.school.users.map(&:id)).to eq([profile.user.id])
    end
  end
end
