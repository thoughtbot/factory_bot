describe "sequences" do
  include FactoryBot::Syntax::Methods

  require "ostruct"

  # = On Success
  # ======================================================================
  #
  describe "on success" do
    it "generates several values in the correct format" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence(:email) { |n| "global-#{n}@example.com" }

        factory :user do
          sequence(:email) { |n| "user-#{n}@example.com" }
        end
      end

      expect(generate(:email)).to eq "global-1@example.com"
      expect(generate(:email)).to eq "global-2@example.com"
      expect(generate(:email)).to eq "global-3@example.com"

      expect(generate(:user, :email)).to eq "user-1@example.com"
      expect(generate(:user, :email)).to eq "user-2@example.com"
      expect(generate(:user, :email)).to eq "user-3@example.com"
    end

    it "generates sequential numbers if no block is given" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence :global_order

        factory :user do
          sequence :user_order
        end
      end

      expect(generate(:global_order)).to eq 1
      expect(generate(:global_order)).to eq 2
      expect(generate(:global_order)).to eq 3

      expect(generate(:user, :user_order)).to eq 1
      expect(generate(:user, :user_order)).to eq 2
      expect(generate(:user, :user_order)).to eq 3
    end

    it "generates aliases for the sequence that reference the same block" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence(:size, aliases: [:count, :length]) { |n| "global-called-#{n}" }

        factory :user, aliases: [:author, :commenter] do
          sequence(:size, aliases: [:count, :length]) { |n| "user-called-#{n}" }
        end
      end

      expect(generate(:size)).to eq "global-called-1"
      expect(generate(:count)).to eq "global-called-2"
      expect(generate(:length)).to eq "global-called-3"

      expect(generate(:user, :size)).to eq "user-called-1"
      expect(generate(:author, :count)).to eq "user-called-2"
      expect(generate(:commenter, :length)).to eq "user-called-3"
    end

    it "generates aliases for the sequence that reference the same block and retains value" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence(:size, "a", aliases: [:count, :length]) { |n| "global-called-#{n}" }

        factory :user, aliases: [:author, :commenter] do
          sequence(:size, "x", aliases: [:count, :length]) { |n| "user-called-#{n}" }
        end
      end

      expect(generate(:size)).to eq "global-called-a"
      expect(generate(:count)).to eq "global-called-b"
      expect(generate(:length)).to eq "global-called-c"

      expect(generate(:user, :size)).to eq "user-called-x"
      expect(generate(:author, :count)).to eq "user-called-y"
      expect(generate(:commenter, :length)).to eq "user-called-z"
    end

    it "generates sequences after lazy loading an initial value from a proc" do
      loaded = false

      FactoryBot.define do
        sequence :count, proc {
          loaded = true
          "d"
        }
      end

      expect(loaded).to be false

      first_value = generate(:count)
      another_value = generate(:count)

      expect(loaded).to be true

      expect(first_value).to eq "d"
      expect(another_value).to eq "e"
    end

    it "generates sequences after lazy loading an initial value from an object responding to call" do
      define_class("HasCallMethod") do
        def initialise
          @called = false
        end

        def called?
          @called
        end

        def call
          @called = true
          "ABC"
        end
      end

      has_call_method_instance = HasCallMethod.new

      FactoryBot.define do
        sequence :letters, has_call_method_instance
      end

      expect(has_call_method_instance).not_to be_called

      first_value = generate(:letters)
      another_value = generate(:letters)

      expect(has_call_method_instance).to be_called

      expect(first_value).to eq "ABC"
      expect(another_value).to eq "ABD"
    end

    it "generates few values of the sequence" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence(:email) { |n| "global-#{n}@example.com" }

        factory :user do
          sequence(:email) { |n| "user-#{n}@example.com" }
        end
      end

      global_values = generate_list(:email, 3)
      expect(global_values[0]).to eq "global-1@example.com"
      expect(global_values[1]).to eq "global-2@example.com"
      expect(global_values[2]).to eq "global-3@example.com"

      user_values = generate_list(:user, :email, 3)
      expect(user_values[0]).to eq "user-1@example.com"
      expect(user_values[1]).to eq "user-2@example.com"
      expect(user_values[2]).to eq "user-3@example.com"
    end

    it "generates few values of the sequence with a given scope" do
      define_class("User") { attr_accessor :name, :email }

      FactoryBot.define do
        factory :user do
          sequence(:email) { |n| "#{name}-#{n}@example.com" }
        end
      end

      test_scope = OpenStruct.new(name: "Jester")
      user_values = generate_list(:user, :email, 3, scope: test_scope)

      expect(user_values[0]).to eq "Jester-1@example.com"
      expect(user_values[1]).to eq "Jester-2@example.com"
      expect(user_values[2]).to eq "Jester-3@example.com"
    end
  end # "on success"

  # = On Failure
  # ======================================================================
  #
  describe "on failure" do
    it "it fails with an unknown sequence or factory name" do
      define_class("User") { attr_accessor :email }

      FactoryBot.define do
        sequence :counter
        factory :user do
          sequence counter
        end
      end

      expect { generate(:test).to raise_error KeyError, /Sequence not registered: :test/ }
      expect { generate(:user, :test).to raise_error KeyError, /Sequence not registered: user:test/ }
      expect { generate(:admin, :counter).to raise_error KeyError, /Sequence not registered: "admin:counter"/ }
    end

    it "it fails with a sequence that references a scoped attribute, but no scope given" do
      define_class("User") { attr_accessor :name, :age, :info }

      FactoryBot.define do
        factory :user do
          sequence(:info) { |n| "#{name}:#{age + n}" }
        end
      end

      jester = FactoryBot.build(:user, name: "Jester", age: 21)

      expect(generate(:user, :info, scope: jester)).to eq "Jester:23"

      expect { generate(:user, :info) }
        .to raise_error ArgumentError, "Sequence 'user/info' failed to return a value. " \
                                       "Perhaps it needs a scope to operate? (scope: <object>)"
    end
  end # "on failure"
end
