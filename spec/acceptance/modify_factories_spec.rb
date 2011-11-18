require "spec_helper"

describe "modifying factories" do
  include FactoryWoman::Syntax::Methods

  before do
    define_model('User', :name => :string, :admin => :boolean, :email => :string, :login => :string)

    FactoryWoman.define do
      sequence(:email) {|n| "user#{n}@example.com" }

      factory :user do
        email

        after_create do |user|
          user.login = user.name.upcase if user.name
        end

        factory :admin do
          admin true
        end
      end
    end
  end

  context "simple modification" do
    before do
      FactoryWoman.modify do
        factory :user do
          name "Great User"
        end
      end
    end

    subject     { create(:user) }
    its(:name)  { should == "Great User" }
    its(:login) { should == "GREAT USER" }

    it "doesn't allow the factory to be subsequently defined" do
      expect do
        FactoryWoman.define { factory :user }
      end.to raise_error(FactoryWoman::DuplicateDefinitionError, "Factory already registered: user")
    end

    it "does allow the factory to be subsequently modified" do
      FactoryWoman.modify do
        factory :user do
          name "Overridden again!"
        end
      end

      create(:user).name.should == "Overridden again!"
    end
  end

  context "adding callbacks" do
    before do
      FactoryWoman.modify do
        factory :user do
          name "Great User"
          after_create do |user|
            user.name = user.name.downcase
            user.login = nil
          end
        end
      end
    end

    subject { create(:user) }

    its(:name)  { should == "great user" }
    its(:login) { should be_nil }
  end

  context "reusing traits" do
    before do
      FactoryWoman.define do
        trait :rockstar do
          name "Johnny Rockstar!!!"
        end
      end

      FactoryWoman.modify do
        factory :user do
          rockstar
          email { "#{name}@example.com" }
        end
      end
    end

    subject     { create(:user) }

    its(:name)  { should == "Johnny Rockstar!!!" }
    its(:email) { should == "Johnny Rockstar!!!@example.com" }
    its(:login) { should == "JOHNNY ROCKSTAR!!!" }
  end

  context "redefining attributes" do
    before do
      FactoryWoman.modify do
        factory :user do
          email { "#{name}-modified@example.com" }
          name "Great User"
        end
      end
    end

    context "creating user" do
      context "without overrides" do
        subject     { create(:user) }

        its(:name)  { should == "Great User" }
        its(:email) { should == "Great User-modified@example.com" }
      end

      context "overriding dynamic attributes" do
        subject     { create(:user, :email => "perfect@example.com") }

        its(:name)  { should == "Great User" }
        its(:email) { should == "perfect@example.com" }
      end

      context "overriding static attributes" do
        subject     { create(:user, :name => "wonderful") }

        its(:name)  { should == "wonderful" }
        its(:email) { should == "wonderful-modified@example.com" }
      end
    end

    context "creating admin" do
      context "without overrides" do
        subject     { create(:admin) }

        its(:name)  { should == "Great User" }
        its(:email) { should == "Great User-modified@example.com" }
        its(:admin) { should be_true }
      end

      context "overriding dynamic attributes" do
        subject     { create(:admin, :email => "perfect@example.com") }

        its(:name)  { should == "Great User" }
        its(:email) { should == "perfect@example.com" }
        its(:admin) { should be_true }
      end

      context "overriding static attributes" do
        subject     { create(:admin, :name => "wonderful") }

        its(:name)  { should == "wonderful" }
        its(:email) { should == "wonderful-modified@example.com" }
        its(:admin) { should be_true }
      end
    end
  end

  it "doesn't overwrite already defined child's attributes" do
    FactoryWoman.modify do
      factory :user do
        admin false
      end
    end
    create(:admin).should be_admin
  end

  it "allows for overriding child classes" do
    FactoryWoman.modify do
      factory :admin do
        admin false
      end
    end

    create(:admin).should_not be_admin
  end

  it "raises an exception if the factory was not defined before" do
    lambda {
      FactoryWoman.modify do
        factory :unknown_factory
      end
    }.should raise_error(ArgumentError)
  end
end
