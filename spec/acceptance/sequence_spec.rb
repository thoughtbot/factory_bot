describe "sequences" do
  include FactoryBot::Syntax::Methods

  require "ostruct"

  describe "on success" do
    it "generates several values in the correct format" do
      FactoryBot.define do
        sequence(:email) { |n| "global-#{n}@example.com" }
      end

      expect(generate(:email)).to eq "global-1@example.com"
      expect(generate(:email)).to eq "global-2@example.com"
      expect(generate(:email)).to eq "global-3@example.com"
    end

    it "generates sequential numbers if no block is given" do
      FactoryBot.define do
        sequence :global_order
      end

      expect(generate(:global_order)).to eq 1
      expect(generate(:global_order)).to eq 2
      expect(generate(:global_order)).to eq 3
    end

    it "generates aliases for the sequence that reference the same block" do
      FactoryBot.define do
        sequence(:size, aliases: [:count, :length]) { |n| "global-called-#{n}" }
      end

      expect(generate(:size)).to eq "global-called-1"
      expect(generate(:count)).to eq "global-called-2"
      expect(generate(:length)).to eq "global-called-3"
    end

    it "generates aliases for the sequence that reference the same block and retains value" do
      FactoryBot.define do
        sequence(:size, "a", aliases: [:count, :length]) { |n| "global-called-#{n}" }
      end

      expect(generate(:size)).to eq "global-called-a"
      expect(generate(:count)).to eq "global-called-b"
      expect(generate(:length)).to eq "global-called-c"
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

    it "generates sequences from an enumerator" do
      FactoryBot.define do
        sequence :priority, %i[low high].cycle
        sequence :name, %w[Alice Bob].to_enum
      end

      expect(generate_list(:priority, 3)).to eq [:low, :high, :low]
      expect(generate_list(:name, 2)).to eq %w[Alice Bob]
      expect { generate(:name) }.to raise_error StopIteration
    end

    it "generates few values of the sequence" do
      FactoryBot.define do
        sequence(:email) { |n| "global-#{n}@example.com" }
      end

      global_values = generate_list(:email, 3)
      expect(global_values[0]).to eq "global-1@example.com"
      expect(global_values[1]).to eq "global-2@example.com"
      expect(global_values[2]).to eq "global-3@example.com"
    end

    it "generates few values of the sequence with a given scope" do
      FactoryBot.define do
        sequence(:email) { |n| "#{name}-#{n}@example.com" }
      end

      test_scope = OpenStruct.new(name: "Jester")
      user_values = generate_list(:email, 3, scope: test_scope)

      expect(user_values[0]).to eq "Jester-1@example.com"
      expect(user_values[1]).to eq "Jester-2@example.com"
      expect(user_values[2]).to eq "Jester-3@example.com"
    end

    it "rewinds every sequence" do
      FactoryBot.define do
        sequence(:email) { |n| "global-#{n}@example.com" }
      end

      generate_list(:email, 3)
      FactoryBot.rewind_sequences

      expect(generate(:email)).to eq "global-1@example.com"
    end
  end

  describe "on failure" do
    it "fails with an unknown sequence name" do
      FactoryBot.define do
        sequence :counter
      end

      expect { generate(:test) }.to raise_error KeyError, /Sequence not registered: "test"/
    end

    it "fails with a sequence that references a scoped attribute, but no scope given" do
      FactoryBot.define do
        sequence(:info) { |n| "#{name}:#{age + n}" }
      end

      jester = OpenStruct.new(name: "Jester", age: 21)

      expect(generate(:info, scope: jester)).to eq "Jester:22"

      expect { generate(:info) }
        .to raise_error ArgumentError, "Sequence 'info' failed to return a value. " \
          "Perhaps it needs a scope to operate? (scope: <object>)"
    end
  end
end
