describe FactoryBot::Attribute::Dynamic do
  let(:name)  { :first_name }
  let(:block) { -> {} }

  subject { FactoryBot::Attribute::Dynamic.new(name, false, block) }

  its(:name) { should eq name }

  context "with a block returning a static value" do
    let(:block) { -> { "value" } }

    it "returns the value when executing the proc" do
      expect(subject.to_proc.call).to eq "value"
    end
  end

  context "with a block returning its block-level variable" do
    let(:block) { ->(thing) { thing } }

    it "returns self when executing the proc" do
      expect(subject.to_proc.call).to eq subject
    end
  end

  context "with a block referencing an attribute on the attribute" do
    let(:block)  { -> { attribute_defined_on_attribute } }
    let(:result) { "other attribute value" }

    module MissingMethods
      def attribute_defined_on_attribute(*args); end
    end

    before do
      # Define an '#attribute_defined_on_attribute' instance method allowing it
      # be mocked. Ususually this is determined via '#method_missing'
      subject.extend(MissingMethods)

      allow(subject).
        to receive(:attribute_defined_on_attribute).and_return result
    end

    it "evaluates the attribute from the attribute" do
      expect(subject.to_proc.call).to eq result
    end
  end

  context "with a block returning a sequence" do
    let(:block) { -> { FactoryBot.register_sequence(FactoryBot::Sequence.new(:email, 1) { |n| "foo#{n}" }) } }

    it "raises a sequence abuse error" do
      expect { subject.to_proc.call }.to raise_error(FactoryBot::SequenceAbuseError)
    end
  end
end

describe FactoryBot::Attribute::Dynamic, "with a string name" do
  subject    { FactoryBot::Attribute::Dynamic.new("name", false, -> {}) }
  its(:name) { should eq :name }
end
