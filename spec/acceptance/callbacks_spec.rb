describe "callbacks" do
  before do
    define_model("User", first_name: :string, last_name: :string)
  end

  context "with strategy callbacks" do
    before do
      FactoryBot.define do
        factory :user_with_callbacks, class: :user do
          after(:stub) { |user| user.first_name = "Stubby" }
          after(:build) { |user| user.first_name = "Buildy" }
          after(:create) { |user| user.last_name = "Createy" }
        end

        factory :user_with_inherited_callbacks, parent: :user_with_callbacks do
          after(:stub) { |user| user.last_name = "Double-Stubby" }
          after(:build) { |user| user.first_name = "Child-Buildy" }
        end
      end
    end

    it "runs the after(:stub) callback when stubbing" do
      user = FactoryBot.build_stubbed(:user_with_callbacks)
      expect(user.first_name).to eq "Stubby"
    end

    it "runs the after(:build) callback when building" do
      user = FactoryBot.build(:user_with_callbacks)
      expect(user.first_name).to eq "Buildy"
    end

    it "runs both the after(:build) and after(:create) callbacks when creating" do
      user = FactoryBot.create(:user_with_callbacks)
      expect(user.first_name).to eq "Buildy"
      expect(user.last_name).to eq "Createy"
    end

    it "runs both the after(:stub) callback on the factory and the inherited after(:stub) callback" do
      user = FactoryBot.build_stubbed(:user_with_inherited_callbacks)
      expect(user.first_name).to eq "Stubby"
      expect(user.last_name).to eq "Double-Stubby"
    end

    it "runs child callback after parent callback" do
      user = FactoryBot.build(:user_with_inherited_callbacks)
      expect(user.first_name).to eq "Child-Buildy"
    end
  end # with strategy callbacks

  context "with before(:all) and after(:all) included" do
    context "are executed in the correct order" do
      before do
        FactoryBot.define do
          before(:all) { TestLog << "global before-all called" }
          after(:all) { TestLog << "global after-all called" }
          after(:build) { TestLog << "global after-build called" }
          before(:create) { TestLog << "global before-create called" }
          after(:create) { TestLog << "global after-create called" }

          factory :parent, class: :user do
            before(:all) { TestLog << "parent before-all called" }
            after(:all) { TestLog << "parent after-all called" }
            after(:build) { TestLog << "parent after-build called" }
            before(:create) { TestLog << "parent before-create called" }
            after(:create) { TestLog << "parent after-create called" }

            trait :parent_trait_1 do
              before(:all) { TestLog << "parent-trait-1 before-all called" }
              after(:all) { TestLog << "parent-trait-1 after-all called" }
              after(:build) { TestLog << "parent-trait-1 after-build called" }
              before(:create) { TestLog << "parent-trait-1 before-create called" }
              after(:create) { TestLog << "parent-trait-1 after-create called" }
            end

            trait :parent_trait_2 do
              before(:all) { TestLog << "parent-trait-2 before-all called" }
              after(:all) { TestLog << "parent-trait-2 after-all called" }
              after(:build) { TestLog << "parent-trait-2 after-build called" }
              before(:create) { TestLog << "parent-trait-2 before-create called" }
              after(:create) { TestLog << "parent-trait-2 after-create called" }
            end
          end

          factory :child, parent: :parent do
            before(:all) { TestLog << "child before-all called" }
            after(:create) { TestLog << "child after-create called" }
            after(:build) { TestLog << "child after-build called" }
            before(:create) { TestLog << "child before-create called" }
            after(:all) { TestLog << "child after-all called" }

            trait :child_trait do
              before(:all) { TestLog << "child-trait before-all called" }
              after(:all) { TestLog << "child-trait after-all called" }
              after(:build) { TestLog << "child-trait after-build called" }
              before(:create) { TestLog << "child-trait before-create called" }
              after(:create) { TestLog << "child-trait after-create called" }
            end
          end
        end
      end

      before(:each) { TestLog.reset! }

      it "with trait callbacks executed in the order requested" do
        # Note: trait callbacks are executed AFTER any factory callbacks and
        #       in the order they are requested.
        #
        FactoryBot.create(:child, :parent_trait_2, :child_trait, :parent_trait_1)

        expect(TestLog.size).to eq 30

        # before(:all)
        expect(TestLog[0..5]).to eq [
          "global before-all called",
          "parent before-all called",
          "child before-all called",
          "parent-trait-2 before-all called",
          "child-trait before-all called",
          "parent-trait-1 before-all called"
        ]

        # after(:build)
        expect(TestLog[6..11]).to eq [
          "global after-build called",
          "parent after-build called",
          "child after-build called",
          "parent-trait-2 after-build called",
          "child-trait after-build called",
          "parent-trait-1 after-build called"
        ]

        # before(:create)
        expect(TestLog[12..17]).to eq [
          "global before-create called",
          "parent before-create called",
          "child before-create called",
          "parent-trait-2 before-create called",
          "child-trait before-create called",
          "parent-trait-1 before-create called"
        ]

        # after(:create)
        expect(TestLog[18..23]).to eq [
          "global after-create called",
          "parent after-create called",
          "child after-create called",
          "parent-trait-2 after-create called",
          "child-trait after-create called",
          "parent-trait-1 after-create called"
        ]

        # after(:all)
        expect(TestLog[24..29]).to eq [
          "global after-all called",
          "parent after-all called",
          "child after-all called",
          "parent-trait-2 after-all called",
          "child-trait after-all called",
          "parent-trait-1 after-all called"
        ]
      end
    end # ordered correctly

    context "with context provided to before(:all)" do
      before(:each) { TestLog.reset! }

      it "receives 'nil' as the instance" do
        FactoryBot.define do
          before(:all) { |user| TestLog << "Global instance: #{user}" }

          factory :user do
            before(:all) { |user| TestLog << "Factory instance: #{user}" }
          end
        end

        FactoryBot.build(:user)
        expect(TestLog.first).to eq "Global instance: "
        expect(TestLog.last).to eq "Factory instance: "
      end

      it "receives the context, without an instance" do
        FactoryBot.define do
          before(:all) do |user, context|
            TestLog << "Global strategy: #{context.instance_values["build_strategy"].to_sym}"
            TestLog << "Global instance: #{context.instance}"
          end

          factory :user do
            before(:all) do |user, context|
              TestLog << "Factory strategy: #{context.instance_values["build_strategy"].to_sym}"
              TestLog << "Factory instance: #{context.instance}"
            end
          end
        end

        FactoryBot.build(:user)
        expect(TestLog.all).to eq [
          "Global strategy: build",
          "Global instance: ",
          "Factory strategy: build",
          "Factory instance: "
        ]
      end
    end # context: with context provided to before(:all)

    context "with context provided to after(:all)" do
      it "succeeds with the instance provided" do
        FactoryBot.define do
          after(:all) { |user| user.first_name = "Globy" }

          factory :user do
            after(:all) { |user| user.last_name = "Lasty" }
          end
        end

        user = FactoryBot.build(:user)
        expect(user.first_name).to eq "Globy"
        expect(user.last_name).to eq "Lasty"
      end

      it "succeeds with both the instance and context provided" do
        FactoryBot.define do
          after(:all) { |user, context| user.first_name = context.new_first_name }

          factory :user do
            transient do
              new_first_name { "New First Name" }
              new_last_name { "New Last Name" }
            end

            after(:all) { |user, context| user.last_name = context.new_last_name }
          end
        end

        user = FactoryBot.build(:user)
        expect(user.first_name).to eq "New First Name"
        expect(user.last_name).to eq "New Last Name"
      end
    end # context: with context provided to after(:all)
  end # context: with before(:all) and after(:all) callbacks included
end # describe: callbacks

describe "callbacks using Symbol#to_proc" do
  before do
    define_model("User") do
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

  it "runs the callback correctly" do
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
        after(:stub) { generate(:sequence_3) }
        after(:build) { |user| user.first_number = generate(:sequence_1) }
        after(:create) { |user, _evaluator| user.last_number = generate(:sequence_2) }
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
        last_name { "Doe" }

        before(:custom) { |instance| instance.first_name = "Overridden First" }
        after(:custom) { |instance| instance.last_name = "Overridden Last" }
        callback(:totally_custom) do |instance|
          instance.first_name = "Totally"
          instance.last_name = "Custom"
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

describe "binding a callback to multiple callbacks" do
  before do
    define_model("User", name: :string)

    FactoryBot.define do
      factory :user do
        callback(:before_create, :after_stub) do |instance|
          instance.name = instance.name.upcase
        end
      end
    end
  end

  it "binds the callback to creation" do
    expect(FactoryBot.create(:user, name: "John Doe").name).to eq "JOHN DOE"
  end

  it "does not bind the callback to building" do
    expect(FactoryBot.build(:user, name: "John Doe").name).to eq "John Doe"
  end

  it "binds the callback to stubbing" do
    expect(FactoryBot.build_stubbed(:user, name: "John Doe").name).to eq "JOHN DOE"
  end
end

describe "global callbacks" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User", name: :string)
    define_model("Company", name: :string)

    FactoryBot.define do
      after :build do |object|
        object.name = case object.class.to_s
        when "User" then "John Doe"
        when "Company" then "Acme Suppliers"
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

  it "triggers after build callbacks for all factories" do
    expect(build(:user).name).to eq "john doe"
    expect(create(:user).name).to eq "john doe!!!"
    expect(create(:user, :awesome).name).to eq "A___john doe___!!!Z"
    expect(build(:company).name).to eq "ACME SUPPLIERS"
  end
end
