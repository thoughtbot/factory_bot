shared_examples "a sequence" do |options|
  first_value  = options[:first_value]
  second_value = options[:second_value]

  its(:next) { should eq first_value }

  context "when incrementing" do
    before     { subject.next }
    its(:next) { should eq second_value }
  end

  context "after rewinding" do
    before do
      subject.next
      subject.rewind
    end

    its(:next) { should eq first_value }
  end
end

describe FactoryBot::Sequence do
  describe "a basic sequence" do
    let(:name) { :test }
    subject    { FactoryBot::Sequence.new(name) { |n| "=#{n}" } }

    its(:name)  { should eq name }
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

    its(:names) { should eq [:test, :alias, :other] }

    it_behaves_like "a sequence", first_value: "=1", second_value: "=2"
  end

  describe "a sequence with custom value and aliases" do
    subject do
      FactoryBot::Sequence.new(:test, 3, aliases: [:alias, :other]) do |n|
        "=#{n}"
      end
    end

    its(:names) { should eq [:test, :alias, :other] }

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
      expect(subject.next).to eq "=foo"
      expect(subject.next).to eq "=bar"
      expect { subject.next }.to raise_error(StopIteration)
    end

    it_behaves_like "a sequence", first_value: "=foo", second_value: "=bar"
  end

  describe "a custom sequence and scope" do
    subject { FactoryBot::Sequence.new(:name, "A") { |n| "=#{n}#{foo}" } }
    let(:scope) { double("scope", foo: "attribute") }

    it "increments within the correct scope" do
      expect(subject.next(scope)).to eq "=Aattribute"
    end

    context "when incrementing" do
      before { subject.next(scope) }

      it "increments within the correct scope" do
        expect(subject.next(scope)).to eq "=Battribute"
      end
    end

    context "after rewinding" do
      before do
        subject.next(scope)
        subject.rewind
      end

      it "increments within the correct scope" do
        expect(subject.next(scope)).to eq "=Aattribute"
      end
    end
  end
end
