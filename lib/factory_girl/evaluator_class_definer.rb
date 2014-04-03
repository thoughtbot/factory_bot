module FactoryGirl
  # @api private
  class EvaluatorClassDefiner
    def initialize(attributes, parent_class)
      @parent_class = parent_class
      @attributes   = attributes

      attributes.each do |attribute|
        if attribute.respond_to? :class_override
          evaluator_class.define_attribute(attribute.name, attribute.class_override, &attribute.to_proc)
        else
          evaluator_class.define_attribute(attribute.name, &attribute.to_proc)
        end
      end
    end

    def evaluator_class
      @evaluator_class ||= Class.new(@parent_class).tap do |klass|
        klass.attribute_lists ||= []
        klass.attribute_lists += [@attributes]
      end
    end
  end
end
