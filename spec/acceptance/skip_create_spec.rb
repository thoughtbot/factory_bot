describe "skipping the default create" do
  before do
    define_model("User", email: :string)

    FactoryBot.define do
      factory :user do
        skip_create

        email { "john@example.com" }
      end
    end
  end

  it "doesn't execute anything when creating the instance" do
    expect(FactoryBot.create(:user)).not_to be_persisted
  end
end
