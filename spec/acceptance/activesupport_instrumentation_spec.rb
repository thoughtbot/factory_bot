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

describe "using ActiveSupport::Instrumentation to track factory interaction" do
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
