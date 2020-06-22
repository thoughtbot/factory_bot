describe "associations" do
  context "when accidentally using an implicit delcaration for the factory" do
    it "raises an error" do
      define_class("Post")

      FactoryBot.define do
        factory :post do
          author factory: user
        end
      end

      expect { FactoryBot.build(:post) }.to raise_error(
        ArgumentError,
        "Association 'author' received an invalid factory argument.\n" \
        "Did you mean? 'factory: :user'\n"
      )
    end
  end

  context "when accidentally using an implicit delcaration as an override" do
    it "raises an error" do
      define_class("Post")

      FactoryBot.define do
        factory :post do
          author factory: :user, invalid_attribute: implicit_trait
        end
      end

      expect { FactoryBot.build(:post) }.to raise_error(
        ArgumentError,
        "Association 'author' received an invalid attribute override.\n" \
        "Did you mean? 'invalid_attribute: :implicit_trait'\n"
      )
    end
  end
end
