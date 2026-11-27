module FactoryBot
  # @api private
  class Enum
    def initialize(attribute_name, values = nil)
      @attribute_name = attribute_name
      @values = values
    end

    def build_traits(klass)
      enum_pairs(klass).map do |trait_name, value|
        build_trait(trait_name, @attribute_name, value)
      end
    end

    private

    def enum_values(klass)
      @values || klass.send(@attribute_name.to_s.pluralize)
    end

    def enum_pairs(klass)
      values = enum_values(klass)
      return values.to_a if values.is_a?(Hash)

      values.map { |name| name.is_a?(Array) ? name : [name, name] }
    end

    def build_trait(trait_name, attribute_name, value)
      Trait.new(trait_name) do
        add_attribute(attribute_name) { value }
      end
    end
  end
end
