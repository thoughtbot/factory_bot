describe "modifying factories" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User", name: :string, admin: :boolean, email: :string, login: :string)

    FactoryBot.define do
      sequence(:email) { |n| "user#{n}@example.com" }

      factory :user do
        email

        after(:create) do |user|
          user.login = user.name.upcase if user.name
        end

        factory :admin do
          admin { true }
        end
      end
    end
  end

  context "simple modification" do
    before do
      FactoryBot.modify do
        factory :user do
          name { "Great User" }
        end
      end
    end

    subject     { create(:user) }
    its(:name)  { should eq "Great User" }
    its(:login) { should eq "GREAT USER" }

    it "doesn't allow the factory to be subsequently defined" do
      expect do
        FactoryBot.define { factory :user }
      end.to raise_error(FactoryBot::DuplicateDefinitionError, "Factory already registered: user")
    end

    it "does allow the factory to be subsequently modified" do
      FactoryBot.modify do
        factory :user do
          name { "Overridden again!" }
        end
      end

      expect(create(:user).name).to eq "Overridden again!"
    end
  end

  context "adding callbacks" do
    before do
      FactoryBot.modify do
        factory :user do
          name { "Great User" }
          after(:create) do |user|
            user.name = user.name.downcase
            user.login = nil
          end
        end
      end
    end

    subject { create(:user) }

    its(:name)  { should eq "great user" }
    its(:login) { should be_nil }
  end

  context "reusing traits" do
    before do
      FactoryBot.define do
        trait :rockstar do
          name { "Johnny Rockstar!!!" }
        end
      end

      FactoryBot.modify do
        factory :user do
          rockstar
          email { "#{name}@example.com" }
        end
      end
    end

    subject     { create(:user) }

    its(:name)  { should eq "Johnny Rockstar!!!" }
    its(:email) { should eq "Johnny Rockstar!!!@example.com" }
    its(:login) { should eq "JOHNNY ROCKSTAR!!!" }
  end

  context "redefining attributes" do
    before do
      FactoryBot.modify do
        factory :user do
          email { "#{name}-modified@example.com" }
          name { "Great User" }
        end
      end
    end

    context "creating user" do
      context "without overrides" do
        subject     { create(:user) }

        its(:name)  { should eq "Great User" }
        its(:email) { should eq "Great User-modified@example.com" }
      end

      context "overriding the email" do
        subject     { create(:user, email: "perfect@example.com") }

        its(:name)  { should eq "Great User" }
        its(:email) { should eq "perfect@example.com" }
      end

      context "overriding the name" do
        subject     { create(:user, name: "wonderful") }

        its(:name)  { should eq "wonderful" }
        its(:email) { should eq "wonderful-modified@example.com" }
      end
    end

    context "creating admin" do
      context "without overrides" do
        subject     { create(:admin) }

        its(:name)  { should eq "Great User" }
        its(:email) { should eq "Great User-modified@example.com" }
        its(:admin) { should be true }
      end

      context "overriding the email" do
        subject     { create(:admin, email: "perfect@example.com") }

        its(:name)  { should eq "Great User" }
        its(:email) { should eq "perfect@example.com" }
        its(:admin) { should be true }
      end

      context "overriding the name" do
        subject     { create(:admin, name: "wonderful") }

        its(:name)  { should eq "wonderful" }
        its(:email) { should eq "wonderful-modified@example.com" }
        its(:admin) { should be true }
      end
    end
  end

  it "doesn't overwrite already defined child's attributes" do
    FactoryBot.modify do
      factory :user do
        admin { false }
      end
    end
    expect(create(:admin)).to be_admin
  end

  it "allows for overriding child classes" do
    FactoryBot.modify do
      factory :admin do
        admin { false }
      end
    end

    expect(create(:admin)).not_to be_admin
  end

  it "raises an exception if the factory was not defined before" do
    modify_unknown_factory = -> do
      FactoryBot.modify do
        factory :unknown_factory
      end
    end

    expect(modify_unknown_factory).to raise_error(ArgumentError)
  end
end
