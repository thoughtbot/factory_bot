module FactoryGirl
  class EvaluatorClassDefiner
    attr_reader :attributes

    def initialize
      @attributes = []
    end

    def evaluator_class
      @evaluator ||= Class.new(FactoryGirl::Evaluator)
    end

    def set(attribute)
      define_attribute(attribute.name, attribute.to_proc)
      @attributes << attribute.name unless attribute.ignored
    end

    private

    def define_attribute(attribute_name, attribute_proc)
      evaluator_class.send(:define_method, attribute_name) {
        @cached_attributes[attribute_name] ||= instance_exec(&attribute_proc)
      }
    end
  end
end
