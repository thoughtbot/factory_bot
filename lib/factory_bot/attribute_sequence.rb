module FactoryBot
  # @api private
  class AttributeSequence
    attr_reader :expression

    def initialize(&block)
      @expression = block
    end

    def evaluate(index)
      expression.call(index)
    end

    def self.evaluate_attributes(traits_and_overrides, i)
      traits_and_overrides.map do |attribute|
        next attribute unless attribute.is_a?(Hash)

        attribute.transform_values do |value|
          value.is_a?(self) ? value.evaluate(i) : value
        end
      end    
    end
  end
end
