unless ActiveSupport::Notifications.respond_to?(:subscribed)
  module SubscribedBehavior
    def subscribed(callback, *args)
      subscriber = subscribe(*args, &callback)
      yield
    ensure
      unsubscribe(subscriber)
    end
  end

  ActiveSupport::Notifications.extend SubscribedBehavior
end

describe "using ActiveSupport::Instrumentation to track run_factory interaction" do
  let(:slow_user_factory) { FactoryBot::Internal.factory_by_name("slow_user") }
  let(:user_factory) { FactoryBot::Internal.factory_by_name("user") }
  before do
    define_model("User", email: :string)
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
      factory :user do
        email { "john@example.com" }

        factory :slow_user do
          after(:build) { Kernel.sleep(0.1) }
        end
      end

      factory :post do
        trait :with_user do
          user
        end
      end
    end
  end

  it "tracks proper time of creating the record" do
    time_to_execute = 0
    callback = ->(_name, start, finish, _id, _payload) { time_to_execute = finish - start }
    ActiveSupport::Notifications.subscribed(callback, "factory_bot.run_factory") do
      FactoryBot.build(:slow_user)
    end

    expect(time_to_execute).to be >= 0.1
  end

  it "builds the correct payload" do
    tracked_invocations = {}

    callback = ->(_name, _start, _finish, _id, payload) do
      factory_name = payload[:name]
      strategy_name = payload[:strategy]
      factory = payload[:factory]
      tracked_invocations[factory_name] ||= {}
      tracked_invocations[factory_name][strategy_name] ||= 0
      tracked_invocations[factory_name][strategy_name] += 1
      tracked_invocations[factory_name][:factory] = factory
    end

    ActiveSupport::Notifications.subscribed(callback, "factory_bot.run_factory") do
      FactoryBot.build_list(:slow_user, 2)
      FactoryBot.build_list(:user, 5)
      FactoryBot.create_list(:user, 2)
      FactoryBot.attributes_for(:slow_user)
      user = FactoryBot.create(:user)
      FactoryBot.create(:post, user: user)
      FactoryBot.create_list(:post, 2, :with_user)
    end

    expect(tracked_invocations[:slow_user][:build]).to eq(2)
    expect(tracked_invocations[:slow_user][:attributes_for]).to eq(1)
    expect(tracked_invocations[:slow_user][:factory]).to eq(slow_user_factory)
    expect(tracked_invocations[:user][:build]).to eq(5)
    expect(tracked_invocations[:user][:factory]).to eq(user_factory)
    expect(tracked_invocations[:user][:create]).to eq(5)
  end
end

describe "using ActiveSupport::Instrumentation to track compile_factory interaction" do
  before do
    define_model("User", name: :string, email: :string)

    FactoryBot.define do
      factory :user do
        sequence(:email) { |n| "user_#{n}@example.com" }

        name { "User" }

        trait :special do
          name { "Special User" }
        end
      end
    end
  end

  it "tracks proper time of compiling the factory" do
    time_to_execute = {user: 0}
    callback = ->(_name, start, finish, _id, payload) {
      time_to_execute[payload[:name]] = (finish - start)
    }
    ActiveSupport::Notifications.subscribed(callback, "factory_bot.compile_factory") do
      FactoryBot.build(:user)
    end

    expect(time_to_execute[:user]).to be > 0
  end

  it "builds the correct payload" do
    tracked_payloads = []
    callback = ->(_name, _start, _finish, _id, payload) { tracked_payloads << payload }

    ActiveSupport::Notifications.subscribed(callback, "factory_bot.compile_factory") do
      FactoryBot.build(:user, :special)
    end

    factory_payload = tracked_payloads.detect { |payload| payload[:name] == :user }
    expect(factory_payload[:class]).to eq(User)
    expect(factory_payload[:attributes].map(&:name)).to eq([:email, :name])
    expect(factory_payload[:traits].map(&:name)).to eq(["special"])

    trait_payload = tracked_payloads.detect { |payload| payload[:name] == "special" }
    expect(trait_payload[:class]).to eq(User)
    expect(trait_payload[:attributes].map(&:name)).to eq([:name])
    expect(trait_payload[:traits].map(&:name)).to eq(["special"])
  end

  context "when factory with base traits" do
    before do
      define_model("Company", name: :string, email: :string)

      FactoryBot.define do
        trait :email do
          email { "#{name}@example.com" }
        end

        factory :company, traits: [:email] do
          name { "Charlie" }
        end
      end
    end

    it "builds the correct payload" do
      tracked_payloads = []
      callback = ->(_name, _start, _finish, _id, payload) { tracked_payloads << payload }

      ActiveSupport::Notifications.subscribed(callback, "factory_bot.compile_factory") do
        FactoryBot.build(:company)
      end

      factory_payload = tracked_payloads.detect { |payload| payload[:name] == :company }
      expect(factory_payload[:class]).to eq(Company)
      expect(factory_payload[:attributes].map(&:name)).to eq([:name])
      expect(factory_payload[:traits].map(&:name)).to eq([])

      trait_payload = tracked_payloads.detect { |payload| payload[:name] == "email" }
      expect(trait_payload[:class]).to eq(Company)
      expect(trait_payload[:attributes].map(&:name)).to eq([:email])
      expect(trait_payload[:traits].map(&:name)).to eq([])
    end
  end

  context "when factory with additional traits" do
    before do
      define_model("Company", name: :string, email: :string)

      FactoryBot.define do
        trait :email do
          email { "#{name}@example.com" }
        end

        factory :company do
          name { "Charlie" }
        end
      end
    end

    it "builds the correct payload" do
      tracked_payloads = []
      callback = ->(_name, _start, _finish, _id, payload) { tracked_payloads << payload }

      ActiveSupport::Notifications.subscribed(callback, "factory_bot.compile_factory") do
        FactoryBot.build(:company, :email)
      end

      factory_payload = tracked_payloads.detect { |payload| payload[:name] == :company }
      expect(factory_payload[:class]).to eq(Company)
      expect(factory_payload[:attributes].map(&:name)).to eq([:name])
      expect(factory_payload[:traits].map(&:name)).to eq([])

      trait_payload = tracked_payloads.detect { |payload| payload[:name] == "email" }
      expect(trait_payload[:class]).to eq(Company)
      expect(trait_payload[:attributes].map(&:name)).to eq([:email])
      expect(trait_payload[:traits].map(&:name)).to eq([])
    end
  end
end
