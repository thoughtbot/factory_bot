describe FactoryBot::Attribute::Dynamic do
  let(:name) { :first_name }
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
    let(:block) { -> { attribute_defined_on_attribute } }
    let(:result) { "other attribute value" }

    before do
      # Define an '#attribute_defined_on_attribute' instance method allowing it
      # be mocked. Ususually this is determined via '#method_missing'
      missing_methods = Module.new {
        def attribute_defined_on_attribute(*args)
        end
      }
      subject.extend(missing_methods)

      allow(subject)
        .to receive(:attribute_defined_on_attribute).and_return result
    end

    it "evaluates the attribute from the attribute" do
      expect(subject.to_proc.call).to eq result
    end
  end

  context "with a block returning a sequence" do
    let(:block) do
      -> do
        FactoryBot::Internal.register_sequence(
          FactoryBot::Sequence.new(:email, 1) { |n| "foo#{n}" }
        )
      end
    end

    it "raises a sequence abuse error" do
      expect { subject.to_proc.call }.to raise_error(FactoryBot::SequenceAbuseError)
    end
  end
end

describe FactoryBot::Attribute::Dynamic, "with a string name" do
  subject { FactoryBot::Attribute::Dynamic.new("name", false, -> {}) }
  its(:name) { should eq :name }
end
