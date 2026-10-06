describe FactoryBot::Declaration::Implicit do
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

    context "when one is transient and the other isn't" do
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
