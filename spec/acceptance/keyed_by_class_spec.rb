describe "a factory keyed by its class" do
  it "is not registered" do
    define_model("User")

    FactoryBot.define do
      factory :user
    end

    expect { FactoryBot.create(User) }.to raise_error(KeyError, /Factory not registered: User/)
  end
end
