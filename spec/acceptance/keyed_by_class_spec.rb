describe "finding factories keyed by class instead of symbol" do
  before do
    define_model("User") do
      attr_accessor :name, :email
    end

    FactoryBot.define do
      factory :user
    end
  end

  it "doesn't find the factory" do
    expect { FactoryBot.create(User) }.to(
      raise_error(ArgumentError, "Factory not registered: User"),
    )
  end
end
