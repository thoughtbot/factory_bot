describe "FactoryBot.reload" do
  it "does not reset the enum trait setting" do
    with_temporary_assignment(FactoryBot, :automatically_define_enum_traits, false) do
      FactoryBot.reload

      expect(FactoryBot.automatically_define_enum_traits).to be false
    end
  end

  it "resets global callbacks and definitions" do
    define_model("User", name: :string)
    FactoryBot.define do
      after(:build) { |user| user.name = "global" }
      factory :user
    end

    FactoryBot.reload

    expect { FactoryBot.build(:user) }.to raise_error(KeyError)
    FactoryBot.define { factory :user }
    expect(FactoryBot.build(:user).name).to be_nil
  end
end
