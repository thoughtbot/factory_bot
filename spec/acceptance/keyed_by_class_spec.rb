require "spec_helper"

describe "finding factories keyed by class instead of symbol" do
  before do
    define_model("User") do
      attr_accessor :name, :email
    end

    FactoryGirl.define do
      factory :user do
        name "John Doe"
        sequence(:email) { |n| "person#{n}@example.com" }
      end
    end
  end

  context "when deprecated class lookup if allowed", :silence_deprecation do
    it "allows interaction based on class name" do
      user = FactoryGirl.create User, email: "person@example.com"
      expect(user.email).to eq "person@example.com"
      expect(user.name).to eq "John Doe"
    end
  end

  context "when class lookup is disallowed" do
    it "doesn't find the factory" do
      FactoryGirl.allow_class_lookup = false
      expect { FactoryGirl.create(User) }.to(
        raise_error(ArgumentError, "Factory not registered: User"),
      )
    end
  end
end
