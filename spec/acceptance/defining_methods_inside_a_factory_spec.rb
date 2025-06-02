describe "defining methods inside FactoryBot" do
  it "raises with a meaningful message" do
    define_model("User")

    bad_factory_definition = -> do
      FactoryBot.define do
        factory :user do
          def generate_name
            "John Doe"
          end
        end
      end
    end

    expect(&bad_factory_definition).to raise_error(
      FactoryBot::MethodDefinitionError,
      /Defining methods in blocks \(trait or factory\) is not supported \(generate_name\)/
    )
  end

  it "accepts a method named :definition when set through :method_missing" do
    define_model("User", definition: :string)

    FactoryBot.define do
      factory :user do
        definition do
          "Jester"
        end
      end
    end

    user = FactoryBot.build(:user)
    expect(user.definition).to eq("Jester")
  end
end
