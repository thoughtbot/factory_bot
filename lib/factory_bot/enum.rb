module FactoryBot
  # Expands `traits_for_enum :status, values` (or an ActiveRecord enum) into
  # one trait per value when the factory is compiled.
  Enum = Data.define(:attribute_name, :values) do
    def traits(build_class)
      attribute = attribute_name

      enum_values(build_class).map do |trait_name, value|
        trait_value = value.nil? ? trait_name : value
        Trait.build(trait_name) { add_attribute(attribute) { trait_value } }
      end
    end

    private

    def enum_values(build_class)
      values || build_class.public_send(attribute_name.to_s.pluralize)
    end
  end
end
