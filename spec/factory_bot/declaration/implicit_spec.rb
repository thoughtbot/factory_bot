describe FactoryBot::Declaration::Implicit do
  context "with a known factory" do
    it "creates an association attribute" do
      allow(FactoryBot.factories).to receive(:registered?).and_return true

      declaration = FactoryBot::Declaration::Implicit.new(:name)
      attribute = declaration.to_attributes.first

      expect(attribute).to be_association
    end

    it "has the correct factory name" do
      allow(FactoryBot.factories).to receive(:registered?).and_return true
      name = :factory_name

      declaration = FactoryBot::Declaration::Implicit.new(name)
      attribute = declaration.to_attributes.first

      expect(attribute.factory).to eq(name)
    end
  end

  context "with a known sequence" do
    it "does not create an association attribute" do
      allow(FactoryBot::Internal.sequences).to receive(:registered?).and_return true

      declaration = FactoryBot::Declaration::Implicit.new(:name)
      attribute = declaration.to_attributes.first

      expect(attribute).not_to be_association
    end

    it "creates a sequence attribute" do
      allow(FactoryBot::Internal.sequences).to receive(:registered?).and_return true

      declaration = FactoryBot::Declaration::Implicit.new(:name)
      attribute = declaration.to_attributes.first

      expect(attribute).to be_a(FactoryBot::Attribute::Sequence)
    end
  end

  describe "#==" do
    context "when the attributes are equal" do
      it "the objects are equal" do
        declaration = described_class.new(:name, :factory, false)
        other_declaration = described_class.new(:name, :factory, false)

        expect(declaration).to eq(other_declaration)
      end
    end

    context "when the names are different" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, :factory, false)
        other_declaration = described_class.new(:other_name, :factory, false)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when the factories are different" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, :factory, false)
        other_declaration = described_class.new(:name, :other_factory, false)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when one is ignored and the other isn't" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, :factory, false)
        other_declaration = described_class.new(:name, :factory, true)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when comparing against another type of object" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, :factory, false)

        expect(declaration).not_to eq(:not_a_declaration)
      end
    end
  end
end
