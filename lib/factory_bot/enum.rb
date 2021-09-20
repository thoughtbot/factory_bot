module FactoryBot
  # @api private
  class Enum
    def initialize(attribute_name, values = nil, prefix: false, suffix: false)
      @attribute_name = attribute_name
      @values = values
      @prefix = if prefix == true
                  "#{@attribute_name}_"
                elsif prefix
                  "#{prefix}_"
                end

      @suffix = if suffix == true
                  "_#{@attribute_name}"
                elsif suffix
                  "_#{suffix}"
                end
    end

    def build_traits(klass)
      enum_values(klass).map do |trait_name, value|
        build_trait(trait_name, @attribute_name, value || trait_name)
      end
    end

    attr_reader :attribute_name

    private

    def enum_values(klass)
      @values || klass.send(@attribute_name.to_s.pluralize)
    end

    def build_trait(trait_name, attribute_name, value)
      Trait.new("#{@prefix}#{trait_name}#{@suffix}") do
        add_attribute(attribute_name) { value }
      end
    end
  end
end
