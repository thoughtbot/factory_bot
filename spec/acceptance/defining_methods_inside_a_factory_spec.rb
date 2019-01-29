describe "defining methods inside FactoryGirl" do
  it "raises with a meaningful message" do
    define_model("User")

    bad_factory_definition = -> do
      FactoryGirl.define do
        factory :user do
          def generate_name
            "John Doe"
          end
        end
      end
    end

    expect(bad_factory_definition).to raise_error(
      FactoryGirl::MethodDefinitionError,
      /Defining methods in blocks \(trait or factory\) is not supported \(generate_name\)/,
    )
  end
end
