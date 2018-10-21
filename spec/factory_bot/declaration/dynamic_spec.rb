describe FactoryBot::Declaration::Dynamic do
  describe "#==" do
    context "when the attributes are equal" do
      it "the objects are equal" do
        block = -> {}
        declaration = described_class.new(:name, false, block)
        other_declaration = described_class.new(:name, false, block)

        expect(declaration).to eq(other_declaration)
      end
    end

    context "when the names are different" do
      it "the objects are NOT equal" do
        block = -> {}
        declaration = described_class.new(:name, false, block)
        other_declaration = described_class.new(:other_name, false, block)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when the blocks are different" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, false, -> {})
        other_declaration = described_class.new(:name, false, -> {})

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when one is ignored and the other isn't" do
      it "the objects are NOT equal" do
        block = -> {}
        declaration = described_class.new(:name, false, block)
        other_declaration = described_class.new(:name, true, block)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when comparing against another type of object" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, false, -> {})

        expect(declaration).not_to eq(:not_a_declaration)
      end
    end
  end
end
