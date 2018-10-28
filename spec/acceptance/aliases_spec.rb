describe "aliases and overrides" do
  before do
    FactoryBot.aliases << [/one/, "two"]

    define_model("User", two: :string, one: :string)

    FactoryBot.define do
      factory :user do
        two { "set value" }
      end
    end
  end

  subject { FactoryBot.create(:user, one: "override") }
  its(:one) { should eq "override" }
  its(:two) { should be_nil }
end
