describe "defining a child factory before a parent" do
  before do
    define_model("User", name: :string, admin: :boolean, email: :string, upper_email: :string, login: :string)

    FactoryBot.define do
      factory :admin, parent: :user do
        admin { true }
      end

      factory :user do
        name { "awesome" }
      end
    end
  end

  it "creates admin factories correctly" do
    expect(FactoryBot.create(:admin)).to be_admin
  end
end
