module FactoryGirl
  # @api private
  class EvaluatorClassDefiner
    def initialize(attributes, parent_class)
      @parent_class = parent_class
      @attributes   = attributes

      evaluator_class.send :include, AttributesModuleGenerator.new(attributes).to_module
    end

    def evaluator_class
      @evaluator_class ||= Class.new(@parent_class).tap do |klass|
        klass.attribute_lists ||= []
        klass.attribute_lists += [@attributes]
      end
    end
  end
end
