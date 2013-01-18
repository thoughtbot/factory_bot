require 'spec_helper'

describe "callbacks" do
  before do
    define_model("User", first_name: :string, last_name: :string)

    FactoryGirl.define do
      factory :user_with_callbacks, class: :user do
        after(:stub)   { |user| user.first_name = 'Stubby' }
        after(:build)  { |user| user.first_name = 'Buildy' }
        after(:create) { |user| user.last_name  = 'Createy' }
      end

      factory :user_with_inherited_callbacks, parent: :user_with_callbacks do
        after(:stub)  { |user| user.last_name  = 'Double-Stubby' }
        after(:build) { |user| user.first_name = 'Child-Buildy' }
      end
    end
  end

  it "runs the after(:stub) callback when stubbing" do
    user = FactoryGirl.build_stubbed(:user_with_callbacks)
    expect(user.first_name).to eq 'Stubby'
  end

  it "runs the after(:build) callback when building" do
    user = FactoryGirl.build(:user_with_callbacks)
    expect(user.first_name).to eq 'Buildy'
  end

  it "runs both the after(:build) and after(:create) callbacks when creating" do
    user = FactoryGirl.create(:user_with_callbacks)
    expect(user.first_name).to eq 'Buildy'
    expect(user.last_name).to eq 'Createy'
  end

  it "runs both the after(:stub) callback on the factory and the inherited after(:stub) callback" do
    user = FactoryGirl.build_stubbed(:user_with_inherited_callbacks)
    expect(user.first_name).to eq 'Stubby'
    expect(user.last_name).to eq 'Double-Stubby'
  end

  it "runs child callback after parent callback" do
    user = FactoryGirl.build(:user_with_inherited_callbacks)
    expect(user.first_name).to eq 'Child-Buildy'
  end
end

describe "callbacks using syntax methods without referencing FactoryGirl explicitly" do
  before do
    define_model("User", first_name: :string, last_name: :string)

    FactoryGirl.define do
      sequence(:sequence_1)
      sequence(:sequence_2)
      sequence(:sequence_3)

      factory :user do
        after(:stub)   { generate(:sequence_3) }
        after(:build)  {|user| user.first_name = generate(:sequence_1) }
        after(:create) {|user, evaluator| user.last_name = generate(:sequence_2) }
      end
    end
  end

  it "works when the callback has no variables" do
    FactoryGirl.build_stubbed(:user)
    expect(FactoryGirl.generate(:sequence_3)).to eq 2
  end

  it "works when the callback has one variable" do
    expect(FactoryGirl.build(:user).first_name).to eq 1
  end

  it "works when the callback has two variables" do
    expect(FactoryGirl.create(:user).last_name).to eq 1
  end
end

describe "custom callbacks" do
  let(:custom_before) do
    Class.new do
      def result(evaluation)
        evaluation.object.tap do |instance|
          evaluation.notify(:before_custom, instance)
        end
      end
    end
  end

  let(:custom_after) do
    Class.new do
      def result(evaluation)
        evaluation.object.tap do |instance|
          evaluation.notify(:after_custom, instance)
        end
      end
    end
  end

  let(:totally_custom) do
    Class.new do
      def result(evaluation)
        evaluation.object.tap do |instance|
          evaluation.notify(:totally_custom, instance)
        end
      end
    end
  end

  before do
    define_model("User", first_name: :string, last_name: :string) do
      def name
        [first_name, last_name].join(" ")
      end
    end

    FactoryGirl.register_strategy(:custom_before, custom_before)
    FactoryGirl.register_strategy(:custom_after, custom_after)
    FactoryGirl.register_strategy(:totally_custom, totally_custom)

    FactoryGirl.define do
      factory :user do
        first_name "John"
        last_name  "Doe"

        before(:custom) {|instance| instance.first_name = "Overridden First" }
        after(:custom)  {|instance| instance.last_name  = "Overridden Last" }
        callback(:totally_custom) do |instance|
          instance.first_name = "Totally"
          instance.last_name  = "Custom"
        end
      end
    end
  end

  it "runs a custom before callback when the proper strategy executes" do
    expect(FactoryGirl.build(:user).name).to eq "John Doe"
    expect(FactoryGirl.custom_before(:user).name).to eq "Overridden First Doe"
  end

  it "runs a custom after callback when the proper strategy executes" do
    expect(FactoryGirl.build(:user).name).to eq "John Doe"
    expect(FactoryGirl.custom_after(:user).name).to eq "John Overridden Last"
  end

  it "runs a custom callback without prepending before or after when the proper strategy executes" do
    expect(FactoryGirl.build(:user).name).to eq "John Doe"
    expect(FactoryGirl.totally_custom(:user).name).to eq "Totally Custom"
  end
end

describe 'binding a callback to multiple callbacks' do
  before do
    define_model('User', name: :string)

    FactoryGirl.define do
      factory :user do
        callback(:before_create, :after_stub) do |instance|
          instance.name = instance.name.upcase
        end
      end
    end
  end

  it 'binds the callback to creation' do
    expect(FactoryGirl.create(:user, name: 'John Doe').name).to eq 'JOHN DOE'
  end

  it 'does not bind the callback to building' do
    expect(FactoryGirl.build(:user, name: 'John Doe').name).to eq 'John Doe'
  end

  it 'binds the callback to stubbing' do
    expect(FactoryGirl.build_stubbed(:user, name: 'John Doe').name).to eq 'JOHN DOE'
  end
end
