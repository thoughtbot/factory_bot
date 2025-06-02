shared_examples "a sequence" do |options|
  first_value = options[:first_value]
  second_value = options[:second_value]

  it "has a next value equal to its first value" do
    expect(subject.next).to eq first_value
  end

  it "has a next value equal to the 2nd value after being incremented" do
    subject.next

    expect(subject.next).to eq second_value
  end

  it "has a next value equal to the 1st value after rewinding" do
    subject.next
    subject.rewind

    expect(subject.next).to eq first_value
  end
end

describe FactoryBot::Sequence do
  describe ".find" do
    before(:each) do
      define_class("User") { attr_accessor :name }

      FactoryBot.define do
        factory :user do
          trait :with_email do
            sequence(:email) { |n| "user_#{n}@example.com" }
          end
        end
      end
    end

    it "accepts a list of symbols" do
      expect(described_class.find(:user, :with_email, :email)).to be_truthy
    end

    it "accepts a list of strings" do
      expect(described_class.find("user", "with_email", "email")).to be_truthy
    end

    it "accepts a mixture of symbols & strings" do
      expect(described_class.find(:user, "with_email", :email)).to be_truthy
    end

    it "returns nil with a non-matching URI" do
      expect(described_class.find(:user, :email)).to be_nil
    end

    it "raises an exception with no arguments given" do
      expect { described_class.find }
        .to raise_error ArgumentError, /wrong number of arguments, expected 1\+/
    end
  end

  describe ".find_by_uri" do
    before(:each) do
      define_class("User") { attr_accessor :name }

      FactoryBot.define do
        factory :user do
          trait :with_email do
            sequence(:email) { |n| "user_#{n}@example.com" }
          end
        end
      end
    end

    it "accepts a String" do
      expect(described_class.find_by_uri("user/with_email/email")).to be_truthy
    end

    it "accepts a Symbol" do
      expect(described_class.find_by_uri(:"user/with_email/email")).to be_truthy
    end

    it "returns nil with a non-matching URI" do
      expect(described_class.find_by_uri("user/email")).to be_nil
    end

    it "raises an exception with no arguments given" do
      expect { described_class.find_by_uri }
        .to raise_error ArgumentError, /wrong number of arguments \(given 0, expected 1\)/
    end
  end

  describe "a basic sequence" do
    let(:name) { :test }
    subject { FactoryBot::Sequence.new(name) { |n| "=#{n}" } }

    its(:name) { should eq name }
    its(:names) { should eq [name] }

    it_behaves_like "a sequence", first_value: "=1", second_value: "=2"
  end

  describe "a custom sequence" do
    subject { FactoryBot::Sequence.new(:name, "A") { |n| "=#{n}" } }

    it_behaves_like "a sequence", first_value: "=A", second_value: "=B"
  end

  describe "a sequence with aliases using default value" do
    subject do
      FactoryBot::Sequence.new(:test, aliases: [:alias, :other]) do |n|
        "=#{n}"
      end
    end

    it "has the expected names as its names" do
      names = [:foo, :bar, :baz]
      sequence = FactoryBot::Sequence.new(names.first, aliases: names.last(2)) {
        "=#{n}"
      }

      expect(sequence.names).to eq names
    end

    it_behaves_like "a sequence", first_value: "=1", second_value: "=2"
  end

  describe "a sequence with custom value and aliases" do
    subject do
      FactoryBot::Sequence.new(:test, 3, aliases: [:alias, :other]) do |n|
        "=#{n}"
      end
    end

    it "has the expected names as its names" do
      names = [:foo, :bar, :baz]
      sequence = FactoryBot::Sequence.new(names.first, 3, aliases: names.last(2)) {
        "=#{n}"
      }
      expect(sequence.names).to eq names
    end

    it_behaves_like "a sequence", first_value: "=3", second_value: "=4"
  end

  describe "a basic sequence without a block" do
    subject { FactoryBot::Sequence.new(:name) }

    it_behaves_like "a sequence", first_value: 1, second_value: 2
  end

  describe "a custom sequence without a block" do
    subject { FactoryBot::Sequence.new(:name, "A") }

    it_behaves_like "a sequence", first_value: "A", second_value: "B"
  end

  describe "iterating over items in an enumerator" do
    subject do
      FactoryBot::Sequence.new(:name, %w[foo bar].to_enum) { |n| "=#{n}" }
    end

    it "navigates to the next items until no items remain" do
      sequence = FactoryBot::Sequence.new(:name, %w[foo bar].to_enum) { |n| "=#{n}" }
      expect(sequence.next).to eq "=foo"
      expect(sequence.next).to eq "=bar"

      expect { sequence.next }.to raise_error(StopIteration)
    end

    it_behaves_like "a sequence", first_value: "=foo", second_value: "=bar"
  end

  it "a custom sequence and scope increments within the correct scope" do
    sequence = FactoryBot::Sequence.new(:name, "A") { |n| "=#{n}#{foo}" }
    scope = double("scope", foo: "attribute")

    expect(sequence.next(scope)).to eq "=Aattribute"
  end

  it "a custom sequence and scope increments within the correct scope when incrementing" do
    sequence = FactoryBot::Sequence.new(:name, "A") { |n| "=#{n}#{foo}" }
    scope = double("scope", foo: "attribute")
    sequence.next(scope)

    expect(sequence.next(scope)).to eq "=Battribute"
  end

  it "a custom scope increments within the correct scope after rewinding" do
    sequence = FactoryBot::Sequence.new(:name, "A") { |n| "=#{n}#{foo}" }
    scope = double("scope", foo: "attribute")
    sequence.next(scope)
    sequence.rewind

    expect(sequence.next(scope)).to eq "=Aattribute"
  end
end
