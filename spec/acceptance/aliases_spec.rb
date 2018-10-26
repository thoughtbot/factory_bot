describe "aliases and overrides" do
  before do
    FactoryBot.aliases << [/one/, "two"]

    define_model("User", two: :string, one: :string)

    FactoryBot.define do
      factory :user do
        two { "set value" }
      end
    end
  end

  subject { FactoryBot.create(:user, one: "override") }
  its(:one) { should eq "override" }
  its(:two) { should be_nil }

  context "don't alias" do
    before do
      # Enable this to get the tests to pass
      # FactoryBot.aliases = [[/^((?!item_type).)_id/, '\1']]
      define_model("Item", item_type_id: :string, item_type: :string)

      FactoryBot.define do
        factory :item do
          item_type_id { "id value" }
          item_type { "type value" }
        end
      end
    end

    subject { FactoryBot.create(:item, item_type: "some type", item_type_id: "some id") }
    its(:item_type) { should eq "some type" }
    its(:item_type_id) { should eq "some id" }
  end
end
