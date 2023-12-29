describe "Ruby 3.0: attributes_for destructuring syntax" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User", name: :string)

    FactoryBot.define do
      factory :user do
        sequence(:email) { "email_#{_1}@example.com" }
        name { "John Doe" }
      end
    end
  end

  it "supports being destructured" do
    # rubocop:disable Lint/Syntax
    attributes_for(:user) => {name:, **attributes}
    # rubocop:enable Lint/Syntax

    expect(name).to eq("John Doe")
    expect(attributes.keys).to eq([:email])
    expect(attributes.fetch(:email)).to match(/email_\d+@example.com/)
  end
end
