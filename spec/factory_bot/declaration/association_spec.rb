describe FactoryBot::Declaration::Association do
  describe "#==" do
    context "when the attributes are equal" do
      it "the objects are equal" do
        declaration = described_class.new(:name, options: true)
        other_declaration = described_class.new(:name, options: true)

        expect(declaration).to eq(other_declaration)
      end
    end

    context "when the names are different" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, options: true)
        other_declaration = described_class.new(:other_name, options: true)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when the options are different" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name, options: true)
        other_declaration = described_class.new(:name, other_options: true)

        expect(declaration).not_to eq(other_declaration)
      end
    end

    context "when comparing against another type of object" do
      it "the objects are NOT equal" do
        declaration = described_class.new(:name)

        expect(declaration).not_to eq(:not_a_declaration)
      end
    end
  end
end
