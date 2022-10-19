describe "associations" do
  context "when accidentally using an implicit declaration for the factory" do
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

  context "when accidentally using an implicit declaration as an override" do
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
      define_model("Student", school_id: :integer) do
        belongs_to :school
        has_one :profile
      end

      define_model("Profile", school_id: :integer, student_id: :integer) do
        belongs_to :school
        belongs_to :student
      end

      define_model("School") do
        has_many :students
        has_many :profiles
      end

      FactoryBot.define do
        factory :student do
          school
          profile { association :profile, student: instance, school: school }
        end

        factory :profile do
          school
          student { association :student, profile: instance, school: school }
        end

        factory :school
      end

      student = FactoryBot.create(:student)

      expect(student.profile.school).to eq(student.school)
      expect(student.profile.student).to eq(student)
      expect(student.school.students.map(&:id)).to eq([student.id])
      expect(student.school.profiles.map(&:id)).to eq([student.profile.id])

      profile = FactoryBot.create(:profile)

      expect(profile.student.school).to eq(profile.school)
      expect(profile.student.profile).to eq(profile)
      expect(profile.school.profiles.map(&:id)).to eq([profile.id])
      expect(profile.school.students.map(&:id)).to eq([profile.student.id])
    end
  end

  context "when building collection associations" do
    it "builds the association according to the given strategy" do
      define_model("Photo", listing_id: :integer) do
        belongs_to :listing
        attr_accessor :name
      end

      define_model("Listing") do
        has_many :photos
      end

      FactoryBot.define do
        factory :photo

        factory :listing do
          photos { [association(:photo)] }
        end
      end

      created_listing = FactoryBot.create(:listing)

      expect(created_listing.photos.first).to be_a Photo
      expect(created_listing.photos.first).to be_persisted

      built_listing = FactoryBot.build(:listing)

      expect(built_listing.photos.first).to be_a Photo
      expect(built_listing.photos.first).not_to be_persisted

      stubbed_listing = FactoryBot.build_stubbed(:listing)

      expect(stubbed_listing.photos.first).to be_a Photo
      expect(stubbed_listing.photos.first).to be_persisted
      expect { stubbed_listing.photos.first.save! }.to raise_error(
        "stubbed models are not allowed to access the database - Photo#save!()"
      )
    end
  end
end
