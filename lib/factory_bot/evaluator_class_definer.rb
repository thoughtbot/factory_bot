module FactoryBot
  # @api private
  module EvaluatorClassDefiner
    def self.define_evaluator_class(attributes, parent_class)
      Class.new(parent_class).tap do |klass|
        klass.attribute_lists ||= []
        klass.attribute_lists += [attributes]
        attributes.each do |attribute|
          klass.define_attribute(attribute.name, &attribute.to_proc)
        end
      end
    end
  end
end
