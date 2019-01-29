describe "finding factories keyed by class instead of symbol" do
  before do
    define_model("User") do
      attr_accessor :name, :email
    end

    FactoryGirl.define do
      factory :user
    end
  end

  it "doesn't find the factory" do
    expect { FactoryGirl.create(User) }.to(
      raise_error(KeyError, "Factory not registered: #{User.inspect}"),
    )
  end
end
