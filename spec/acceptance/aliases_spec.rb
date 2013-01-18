require "spec_helper"

describe "aliases and overrides" do
  before do
    FactoryGirl.aliases << [/one/, "two"]

    define_model("User", two: :string, one: :string)

    FactoryGirl.define do
      factory :user do
        two "set value"
      end
    end
  end

  subject { FactoryGirl.create(:user, one: "override") }
  its(:one) { should eq "override" }
  its(:two) { should be_nil }
end
