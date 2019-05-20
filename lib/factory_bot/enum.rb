module FactoryBot
  class Enum
    def initialize(attribute_name, values = nil)
      @attribute_name = attribute_name
      @values = values
    end

    def build_traits(klass)
      enum_values(klass).map do |trait_name, value|
        build_trait(trait_name, @attribute_name, value)
      end
    end

    private

    def enum_values(klass)
      case @values
      when Hash
        @values
      when Array
        @values.map { |value| [value, value] }
      else
        klass.send(@attribute_name.to_s.pluralize)
      end
    end

    def build_trait(trait_name, attribute_name, value)
      Trait.new(trait_name) do
        add_attribute(attribute_name) { value }
      end
    end
  end
end
