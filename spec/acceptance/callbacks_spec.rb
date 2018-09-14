describe "callbacks" do
  before do
    define_model("User", first_name: :string, last_name: :string)

    FactoryBot.define do
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
    user = FactoryBot.build_stubbed(:user_with_callbacks)
    expect(user.first_name).to eq 'Stubby'
  end

  it "runs the after(:build) callback when building" do
    user = FactoryBot.build(:user_with_callbacks)
    expect(user.first_name).to eq 'Buildy'
  end

  it "runs both the after(:build) and after(:create) callbacks when creating" do
    user = FactoryBot.create(:user_with_callbacks)
    expect(user.first_name).to eq 'Buildy'
    expect(user.last_name).to eq 'Createy'
  end

  it "runs both the after(:stub) callback on the factory and the inherited after(:stub) callback" do
    user = FactoryBot.build_stubbed(:user_with_inherited_callbacks)
    expect(user.first_name).to eq 'Stubby'
    expect(user.last_name).to eq 'Double-Stubby'
  end

  it "runs child callback after parent callback" do
    user = FactoryBot.build(:user_with_inherited_callbacks)
    expect(user.first_name).to eq 'Child-Buildy'
  end
end

describe 'callbacks using Symbol#to_proc' do
  before do
    define_model('User') do
      def confirmed?
        !!@confirmed
      end

      def confirm!
        @confirmed = true
      end
    end

    FactoryBot.define do
      factory :user do
        after :build, &:confirm!
      end
    end
  end

  it 'runs the callback correctly' do
    user = FactoryBot.build(:user)
    expect(user).to be_confirmed
  end
end

describe "callbacks using syntax methods without referencing FactoryBot explicitly" do
  before do
    define_model("User", first_number: :integer, last_number: :integer)

    FactoryBot.define do
      sequence(:sequence_1)
      sequence(:sequence_2)
      sequence(:sequence_3)

      factory :user do
        after(:stub)   { generate(:sequence_3) }
        after(:build)  { |user| user.first_number = generate(:sequence_1) }
        after(:create) { |user, evaluator| user.last_number = generate(:sequence_2) }
      end
    end
  end

  it "works when the callback has no variables" do
    FactoryBot.build_stubbed(:user)
    expect(FactoryBot.generate(:sequence_3)).to eq 2
  end

  it "works when the callback has one variable" do
    expect(FactoryBot.build(:user).first_number).to eq 1
  end

  it "works when the callback has two variables" do
    expect(FactoryBot.create(:user).last_number).to eq 1
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

    FactoryBot.register_strategy(:custom_before, custom_before)
    FactoryBot.register_strategy(:custom_after, custom_after)
    FactoryBot.register_strategy(:totally_custom, totally_custom)

    FactoryBot.define do
      factory :user do
        first_name { "John" }
        last_name  { "Doe" }

        before(:custom) { |instance| instance.first_name = "Overridden First" }
        after(:custom)  { |instance| instance.last_name  = "Overridden Last" }
        callback(:totally_custom) do |instance|
          instance.first_name = "Totally"
          instance.last_name  = "Custom"
        end
      end
    end
  end

  it "runs a custom before callback when the proper strategy executes" do
    expect(FactoryBot.build(:user).name).to eq "John Doe"
    expect(FactoryBot.custom_before(:user).name).to eq "Overridden First Doe"
  end

  it "runs a custom after callback when the proper strategy executes" do
    expect(FactoryBot.build(:user).name).to eq "John Doe"
    expect(FactoryBot.custom_after(:user).name).to eq "John Overridden Last"
  end

  it "runs a custom callback without prepending before or after when the proper strategy executes" do
    expect(FactoryBot.build(:user).name).to eq "John Doe"
    expect(FactoryBot.totally_custom(:user).name).to eq "Totally Custom"
  end
end

describe 'binding a callback to multiple callbacks' do
  before do
    define_model('User', name: :string)

    FactoryBot.define do
      factory :user do
        callback(:before_create, :after_stub) do |instance|
          instance.name = instance.name.upcase
        end
      end
    end
  end

  it 'binds the callback to creation' do
    expect(FactoryBot.create(:user, name: 'John Doe').name).to eq 'JOHN DOE'
  end

  it 'does not bind the callback to building' do
    expect(FactoryBot.build(:user, name: 'John Doe').name).to eq 'John Doe'
  end

  it 'binds the callback to stubbing' do
    expect(FactoryBot.build_stubbed(:user, name: 'John Doe').name).to eq 'JOHN DOE'
  end
end

describe 'global callbacks' do
  include FactoryBot::Syntax::Methods

  before do
    define_model('User', name: :string)
    define_model('Company', name: :string)

    FactoryBot.define do
      after :build do |object|
        object.name = case object.class.to_s
                      when 'User' then 'John Doe'
                      when 'Company' then 'Acme Suppliers'
                      end
      end

      after :create do |object|
        object.name = "#{object.name}!!!"
      end

      trait :awesome do
        after :build do |object|
          object.name = "___#{object.name}___"
        end

        after :create do |object|
          object.name = "A#{object.name}Z"
        end
      end

      factory :user do
        after :build do |user|
          user.name = user.name.downcase
        end
      end

      factory :company do
        after :build do |company|
          company.name = company.name.upcase
        end
      end
    end
  end

  it 'triggers after build callbacks for all factories' do
    expect(build(:user).name).to eq 'john doe'
    expect(create(:user).name).to eq 'john doe!!!'
    expect(create(:user, :awesome).name).to eq 'A___john doe___!!!Z'
    expect(build(:company).name).to eq 'ACME SUPPLIERS'
  end
end
