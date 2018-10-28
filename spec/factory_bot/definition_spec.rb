describe FactoryBot::Definition do
  subject { described_class.new(:name) }

  it { should delegate(:declare_attribute).to(:declarations) }

  describe "with a name" do
    it "creates a new attribute list with the name passed" do
      name = "great name"
      allow(FactoryBot::DeclarationList).to receive(:new)

      FactoryBot::Definition.new(name)

      expect(FactoryBot::DeclarationList).to have_received(:new).with(name)
    end
  end

  describe "#name" do
    it "returns the name" do
      name = "factory name"
      definition = described_class.new(name)

      expect(definition.name).to eq(name)
    end
  end

  describe "#overridable" do
    let(:list) { double("declaration list", overridable: true) }
    before do
      allow(FactoryBot::DeclarationList).to receive(:new).and_return list
    end

    it "sets the declaration list as overridable" do
      expect(subject.overridable).to eq subject
      expect(list).to have_received(:overridable).once
    end
  end

  describe "defining traits" do
    let(:trait_1) { double("trait") }
    let(:trait_2) { double("trait") }

    it "maintains a list of traits" do
      subject.define_trait(trait_1)
      subject.define_trait(trait_2)
      expect(subject.defined_traits).to include(trait_1, trait_2)
    end

    it "adds only unique traits" do
      subject.define_trait(trait_1)
      subject.define_trait(trait_1)
      expect(subject.defined_traits.size).to eq 1
    end
  end

  describe "adding callbacks" do
    let(:callback_1) { "callback1" }
    let(:callback_2) { "callback2" }

    it "maintains a list of callbacks" do
      subject.add_callback(callback_1)
      subject.add_callback(callback_2)
      expect(subject.callbacks).to eq [callback_1, callback_2]
    end
  end

  describe "#to_create" do
    its(:to_create) { should be_nil }

    it "returns the assigned value when given a block" do
      block = proc { nil }
      subject.to_create(&block)
      expect(subject.to_create).to eq block
    end
  end
end
