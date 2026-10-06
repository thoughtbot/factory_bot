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
  let(:slow_user_factory) { FactoryBot.factories.find(:slow_user) }
  let(:user_factory) { FactoryBot.factories.find(:user) }
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

  it "builds the correct payload", :slow do
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

describe "using ActiveSupport::Instrumentation to track before_run_factory interaction" do
  before do
    define_model("User", email: :string)
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    FactoryBot.define do
      factory :user do
        email { "john@example.com" }
      end

      factory :post do
        trait :with_user do
          user
        end
      end
    end
  end

  it "builds the correct payload" do
    tracked_payloads = []
    callback = ->(_name, _start, _finish, _id, payload) { tracked_payloads << payload }

    ActiveSupport::Notifications.subscribed(callback, "factory_bot.before_run_factory") do
      FactoryBot.build(:user)
      FactoryBot.create(:post, :with_user)
    end

    user_payload = tracked_payloads.detect { |p| p[:name] == :user }
    expect(user_payload[:strategy]).to eq(:build)
    expect(user_payload[:traits]).to eq([])
    expect(user_payload[:overrides]).to eq({})
    expect(user_payload[:factory]).to be_a(FactoryBot::Factory)

    post_payload = tracked_payloads.detect { |p| p[:name] == :post }
    expect(post_payload[:strategy]).to eq(:create)
    expect(post_payload[:traits]).to eq([:with_user])
    expect(post_payload[:factory]).to be_a(FactoryBot::Factory)
  end

  it "fires before run_factory completes" do
    events = []

    before_callback = ->(_name, _start, _finish, _id, payload) {
      events << [:before, payload[:name]]
    }
    run_callback = ->(_name, _start, _finish, _id, payload) {
      events << [:run, payload[:name]]
    }

    ActiveSupport::Notifications.subscribed(before_callback, "factory_bot.before_run_factory") do
      ActiveSupport::Notifications.subscribed(run_callback, "factory_bot.run_factory") do
        FactoryBot.build(:user)
      end
    end

    expect(events).to eq([[:before, :user], [:run, :user]])
  end

  it "captures nested factory call stack" do
    call_stack = []

    before_callback = ->(_name, _start, _finish, _id, payload) {
      call_stack.push(payload[:name])
    }
    run_callback = ->(_name, _start, _finish, _id, payload) {
      call_stack.pop
    }

    stack_during_user_build = nil
    user_before = ->(_name, _start, _finish, _id, payload) {
      stack_during_user_build = call_stack.dup if payload[:name] == :user
    }

    ActiveSupport::Notifications.subscribed(before_callback, "factory_bot.before_run_factory") do
      ActiveSupport::Notifications.subscribed(run_callback, "factory_bot.run_factory") do
        ActiveSupport::Notifications.subscribed(user_before, "factory_bot.before_run_factory") do
          FactoryBot.create(:post, :with_user)
        end
      end
    end

    expect(stack_during_user_build).to eq([:post, :user])
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
