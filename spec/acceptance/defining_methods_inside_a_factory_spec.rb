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

    expect(bad_factory_definition).to raise_error(
      FactoryBot::MethodDefinitionError,
      /Defining methods in blocks \(trait or factory\) is not supported \(generate_name\)/,
    )
  end
end
