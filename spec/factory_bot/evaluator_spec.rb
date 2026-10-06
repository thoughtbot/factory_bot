describe FactoryBot::Evaluator do
  before { define_class("User") { attr_accessor :name, :nickname, :email } }

  it "memoizes attribute values, including nil and false" do
    calls = 0

    FactoryBot.define do
      factory :user do
        name do
          calls += 1
          nil
        end
        nickname { name }
        email { name }
      end
    end

    FactoryBot.build(:user)

    expect(calls).to eq 1
  end

  it "raises a clear error on circular attribute references" do
    FactoryBot.define do
      factory :user do
        name { nickname }
        nickname { name }
      end
    end

    expect { FactoryBot.build(:user) }.to raise_error(
      FactoryBot::AttributeDefinitionError,
      "Circular attribute reference: name -> nickname -> name"
    )
  end

  it "answers respond_to? for attributes, overrides and the instance" do
    FactoryBot.define do
      factory :user do
        name { "x" }
        after(:build) do |_user, evaluator|
          TestLog << evaluator.respond_to?(:name)
          TestLog << evaluator.respond_to?(:nickname)
          TestLog << evaluator.respond_to?(:email=)
          TestLog << evaluator.respond_to?(:nope)
        end
      end
    end

    TestLog.reset!
    FactoryBot.build(:user, nickname: "y")

    expect(TestLog.all).to eq [true, true, true, false]
  end
end
