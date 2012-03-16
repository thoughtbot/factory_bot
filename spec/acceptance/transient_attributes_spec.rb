require "spec_helper"

describe "transient attributes" do
  before do
    define_model("User", name: :string, email: :string)

    FactoryGirl.define do
      sequence(:name) {|n| "John #{n}" }

      factory :user do
        ignore do
          four     { 2 + 2 }
          rockstar true
          upcased  false
        end

        name  { "#{FactoryGirl.generate(:name)}#{" - Rockstar" if rockstar}" }
        email { "#{name.downcase}#{four}@example.com" }

        after_create do |user, evaluator|
          user.name.upcase! if evaluator.upcased
        end
      end
    end
  end

  context "returning attributes for a factory" do
    subject { FactoryGirl.attributes_for(:user, rockstar: true) }
    it { should_not have_key(:four) }
    it { should_not have_key(:rockstar) }
    it { should_not have_key(:upcased) }
    it { should     have_key(:name) }
    it { should     have_key(:email) }
  end

  context "with a transient variable assigned" do
    let(:rockstar)           { FactoryGirl.create(:user, rockstar: true, four: "1234") }
    let(:rockstar_with_name) { FactoryGirl.create(:user, name: "Jane Doe", rockstar: true) }
    let(:upcased_rockstar)   { FactoryGirl.create(:user, rockstar: true, upcased: true) }
    let(:groupie)            { FactoryGirl.create(:user, rockstar: false) }

    it "generates the correct attributes on a rockstar" do
      rockstar.name.should  == "John 1 - Rockstar"
      rockstar.email.should == "john 1 - rockstar1234@example.com"
    end

    it "generates the correct attributes on an upcased rockstar" do
      upcased_rockstar.name.should  == "JOHN 1 - ROCKSTAR"
      upcased_rockstar.email.should == "john 1 - rockstar4@example.com"
    end

    it "generates the correct attributes on a groupie" do
      groupie.name.should  == "John 1"
      groupie.email.should == "john 14@example.com"
    end

    it "generates the correct attributes on a rockstar with a name" do
      rockstar_with_name.name.should  == "Jane Doe"
      rockstar_with_name.email.should == "jane doe4@example.com"
    end
  end

  context "without transient variables assigned" do
    let(:rockstar) { FactoryGirl.create(:user) }

    it "uses the default value of the attribute" do
      rockstar.name.should == "John 1 - Rockstar"
    end
  end
end

describe "transient sequences" do
  before do
    define_model("User", name: :string)

    FactoryGirl.define do
      factory :user do
        ignore do
          sequence(:counter)
        end

        name { "John Doe #{counter}" }
      end
    end
  end

  it "increments sequences correctly" do
    FactoryGirl.build(:user).name.should == "John Doe 1"
    FactoryGirl.build(:user).name.should == "John Doe 2"
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

    FactoryGirl.define do
      factory :user do
        ignore do
          foo { Foo.new('id-of-foo', 'name-of-foo')}
        end

        foo_id   { foo.id }
        foo_name { foo.name }
      end
    end
  end

  it "does not ignore an _id attribute that is an alias for a transient attribute" do
    user = FactoryGirl.build(:user, :foo => Foo.new('passed-in-id-of-foo', 'passed-in-name-of-foo'))
    user.foo_id.should == 'passed-in-id-of-foo'
    user.foo_name.should == 'passed-in-name-of-foo'
  end
end
