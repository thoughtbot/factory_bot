shared_examples "a scoped sequence" do |options|
  first_value = options[:first_value]
  second_value = options[:second_value]

  it "has a next value equal to its first value" do
    expect(subject.next("scope_value")).to eq first_value
  end

  it "has a next value equal to the 2nd value after being incremented" do
    subject.next("scope_value")

    expect(subject.next("scope_value")).to eq second_value
  end

  it "has a next value equal to the 1st value after rewinding" do
    subject.next("scope_value")
    subject.rewind

    expect(subject.next("scope_value")).to eq first_value
  end
end

describe FactoryBot::ScopedSequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject { FactoryBot::ScopedSequence.new(name, :scope_attribute) { |n| "=#{n}" } }

    its(:name) { should eq name }
    its(:names) { should eq [name] }

    it_behaves_like "a scoped sequence", first_value: "=1", second_value: "=2"
  end

  describe "a custom sequence" do
    subject { FactoryBot::ScopedSequence.new(:name, :scope_attribute, "A") { |n| "=#{n}" } }

    it_behaves_like "a scoped sequence", first_value: "=A", second_value: "=B"
  end

  describe "a scoped sequence with aliases using default value" do
    subject do
      FactoryBot::ScopedSequence.new(:test, :scope_attribute, aliases: [:alias, :other]) do |n|
        "=#{n}"
      end
    end

    it "has the expected names as its names" do
      names = [:foo, :bar, :baz]
      sequence = FactoryBot::ScopedSequence.new(names.first, :scope_attribute, aliases: names.last(2)) {
        "=#{n}"
      }

      expect(sequence.names).to eq names
    end

    it_behaves_like "a scoped sequence", first_value: "=1", second_value: "=2"
  end

  describe "a scoped sequence with custom value and aliases" do
    subject do
      FactoryBot::ScopedSequence.new(:test, :scope_attribute, 3, aliases: [:alias, :other]) do |n|
        "=#{n}"
      end
    end

    it "has the expected names as its names" do
      names = [:foo, :bar, :baz]
      sequence = FactoryBot::ScopedSequence.new(names.first, :scope_attribute, 3, aliases: names.last(2)) {
        "=#{n}"
      }
      expect(sequence.names).to eq names
    end

    it_behaves_like "a scoped sequence", first_value: "=3", second_value: "=4"
  end

  describe "a basic sequence without a block" do
    subject { FactoryBot::ScopedSequence.new(:name, :scope_attribute) }

    it_behaves_like "a scoped sequence", first_value: 1, second_value: 2
  end

  describe "a custom sequence without a block" do
    subject { FactoryBot::ScopedSequence.new(:name, :scope_attribute, "A") }

    it_behaves_like "a scoped sequence", first_value: "A", second_value: "B"
  end

  describe "iterating over items in an enumerator" do
    subject do
      FactoryBot::ScopedSequence.new(:name, :scope_attribute, %w[foo bar].to_enum) { |n| "=#{n}" }
    end

    it "navigates to the next items until no items remain" do
      sequence = FactoryBot::ScopedSequence.new(:name, :scope_attribute, %w[foo bar].to_enum) { |n| "=#{n}" }
      expect(sequence.next("scope_value")).to eq "=foo"
      expect(sequence.next("scope_value")).to eq "=bar"

      expect { sequence.next("scope_value") }.to raise_error(StopIteration)
    end

    it_behaves_like "a scoped sequence", first_value: "=foo", second_value: "=bar"
  end

  describe "different value on scope attribute" do
    let(:name) { :test }
    subject { FactoryBot::ScopedSequence.new(name, :scope_attribute) { |n| "=#{n}" } }

    it "generates other sequential number" do
      subject.next("scope_value")
      expect(subject.next("other_value")).to eq "=1"
    end
  end

  it "a custom sequence and scope increments within the correct scope" do
    sequence = FactoryBot::ScopedSequence.new(:name, :scope_attribute, "A") { |n| "=#{n}#{foo}" }
    scope = double("scope", foo: "attribute")

    expect(sequence.next("scope_value", scope)).to eq "=Aattribute"
  end

  it "a custom sequence and scope increments within the correct scope when incrementing" do
    sequence = FactoryBot::ScopedSequence.new(:name, :scope_attribute, "A") { |n| "=#{n}#{foo}" }
    scope = double("scope", foo: "attribute")
    sequence.next("scope_value", scope)

    expect(sequence.next("scope_value", scope)).to eq "=Battribute"
  end

  it "a custom scope increments within the correct scope after rewinding" do
    sequence = FactoryBot::ScopedSequence.new(:name, :scope_attribute, "A") { |n| "=#{n}#{foo}" }
    scope = double("scope", foo: "attribute")
    sequence.next("scope_value", scope)
    sequence.rewind

    expect(sequence.next("scope_value", scope)).to eq "=Aattribute"
  end
end
