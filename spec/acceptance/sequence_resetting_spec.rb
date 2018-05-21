describe "FactoryBot.rewind_sequences" do
  include FactoryBot::Syntax::Methods

  it "resets all sequences back to their starting values" do
    FactoryBot.define do
      sequence(:email) { |n| "somebody#{n}@example.com" }
      sequence(:name, %w[Joe Josh].to_enum)
    end

    2.times do
      generate(:email)
      generate(:name)
    end

    FactoryBot.rewind_sequences

    email = generate(:email)
    name = generate(:name)

    expect(email).to eq "somebody1@example.com"
    expect(name).to eq "Joe"
  end
end
