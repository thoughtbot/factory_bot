describe "transient attributes" do
  before do
    define_model("Country", country_code: :string)
    # define_model("Account", account_number: :string)
    define_model("User", name: :string, email: :string, country_code: :string)

    FactoryBot.define do
      sequence(:name) { |n| "John #{n}" }

      factory :country do
        country_code { 'US' }
      end

      # factory :account do
      #   sequence(:account_number)
      # end

      factory :user do
        transient do
          four     { 2 + 2 }
          rockstar { true }
          upcased  { false }
          country
        end

        name  { "#{FactoryBot.generate(:name)}#{' - Rockstar' if rockstar}" }
        email { "#{name.downcase}#{four}@example.com" }
        country_code { country.country_code }

        after(:create) do |user, evaluator|
          user.name.upcase! if evaluator.upcased
        end
      end
    end
  end

  context "returning attributes for a factory" do
    subject { FactoryBot.attributes_for(:user, rockstar: true) }

    it { should_not have_key(:four) }
    it { should_not have_key(:rockstar) }
    it { should_not have_key(:upcased) }
    it { should_not have_key(:country) }
    # it { should_not have_key(:account) }
    it { should     have_key(:name) }
    it { should     have_key(:email) }
    it { should     have_key(:country_code) }
  end

  context "with a transient variable assigned" do
    let(:rockstar)           { FactoryBot.create(:user, rockstar: true, four: "1234") }
    let(:rockstar_with_name) { FactoryBot.create(:user, name: "Jane Doe", rockstar: true) }
    let(:upcased_rockstar)   { FactoryBot.create(:user, rockstar: true, upcased: true) }
    let(:groupie)            { FactoryBot.create(:user, rockstar: false) }

    it "generates the correct attributes on a rockstar" do
      expect(rockstar.name).to eq "John 1 - Rockstar"
      expect(rockstar.email).to eq "john 1 - rockstar1234@example.com"
    end

    it "generates the correct attributes on an upcased rockstar" do
      expect(upcased_rockstar.name).to eq "JOHN 1 - ROCKSTAR"
      expect(upcased_rockstar.email).to eq "john 1 - rockstar4@example.com"
    end

    it "generates the correct attributes on a groupie" do
      expect(groupie.name).to eq "John 1"
      expect(groupie.email).to eq "john 14@example.com"
    end

    it "generates the correct attributes on a rockstar with a name" do
      expect(rockstar_with_name.name).to eq "Jane Doe"
      expect(rockstar_with_name.email).to eq "jane doe4@example.com"
    end
  end

  context "without transient variables assigned" do
    let(:rockstar) { FactoryBot.create(:user) }

    it "uses the default value of the attribute" do
      expect(rockstar.name).to eq "John 1 - Rockstar"
    end
  end
end

describe "transient sequences" do
  before do
    define_model("User", name: :string)

    FactoryBot.define do
      factory :user do
        transient do
          sequence(:counter)
        end

        name { "John Doe #{counter}" }
      end
    end
  end

  it "increments sequences correctly" do
    expect(FactoryBot.build(:user).name).to eq "John Doe 1"
    expect(FactoryBot.build(:user).name).to eq "John Doe 2"
  end
end

describe "assigning values from a transient attribute" do
  before do
    define_class("User") do
      attr_accessor :foo_id, :foo_name
    end

    define_class("Foo") do
      attr_accessor :id, :name
      def initialize(id, name)
        @id = id
        @name = name
      end
    end

    FactoryBot.define do
      factory :user do
        transient do
          foo { Foo.new("id-of-foo", "name-of-foo") }
        end

        foo_id   { foo.id }
        foo_name { foo.name }
      end
    end
  end

  it "does not ignore an _id attribute that is an alias for a transient attribute" do
    user = FactoryBot.build(:user, foo: Foo.new("passed-in-id-of-foo", "passed-in-name-of-foo"))
    expect(user.foo_id).to eq "passed-in-id-of-foo"
    expect(user.foo_name).to eq "passed-in-name-of-foo"
  end
end
