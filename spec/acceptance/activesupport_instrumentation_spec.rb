require "spec_helper"

unless ActiveSupport::Notifications.respond_to?(:subscribed)
  module SubscribedBehavior
    def subscribed(callback, *args, &block)
      subscriber = subscribe(*args, &callback)
      yield
    ensure
      unsubscribe(subscriber)
    end
  end

  ActiveSupport::Notifications.extend SubscribedBehavior
end

describe "using ActiveSupport::Instrumentation to track factory interaction" do
  before do
    define_model("User", email: :string)
    FactoryGirl.define do
      factory :user do
        email "john@example.com"

        factory :slow_user do
          after(:build) { Kernel.sleep(0.1) }
        end
      end

    end
  end

  it "tracks proper time of creating the record" do
    time_to_execute = 0
    callback = ->(name, start, finish, id, payload) { time_to_execute = finish - start }
    ActiveSupport::Notifications.subscribed(callback, "factory_girl.run_factory") do
      FactoryGirl.build(:slow_user)
    end

    expect(time_to_execute).to be >= 0.1
  end

  it "builds the correct payload" do
    tracked_invocations = {}

    callback = ->(name, start, finish, id, payload) do
      factory_name = payload[:name]
      strategy_name = payload[:strategy]
      tracked_invocations[factory_name] ||= {}
      tracked_invocations[factory_name][strategy_name] ||= 0
      tracked_invocations[factory_name][strategy_name] += 1
    end

    ActiveSupport::Notifications.subscribed(callback, "factory_girl.run_factory") do
      FactoryGirl.build_list(:slow_user, 2)
      FactoryGirl.build_list(:user, 5)
      FactoryGirl.create_list(:user, 2)
      FactoryGirl.attributes_for(:slow_user)
    end

    expect(tracked_invocations[:slow_user]).to eq(build: 2, attributes_for: 1)
    expect(tracked_invocations[:user]).to eq(build: 5, create: 2)
  end
end
