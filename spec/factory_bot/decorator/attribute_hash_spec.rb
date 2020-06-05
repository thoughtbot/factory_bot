describe FactoryBot::Decorator::AttributeHash do
  describe "#attributes" do
    it "returns a hash of attributes" do
      attributes = {attribute_1: :value, attribute_2: :value}
      component = double(:component, attributes)

      decorator = described_class.new(component, [:attribute_1, :attribute_2])

      expect(decorator.attributes).to eq(attributes)
    end

    context "with an attribute called 'attributes'" do
      it "does not call itself recursively" do
        attributes = {attributes: :value}
        component = double(:component, attributes)

        decorator = described_class.new(component, [:attributes])

        expect(decorator.attributes).to eq(attributes)
      end
    end
  end
end
