module FactoryGirl
  class EvaluatorClassDefiner
    def initialize(attributes)
      attributes.each do |attribute|
        define_attribute(attribute.name, attribute.to_proc)
      end
    end

    def evaluator_class
      @evaluator_class ||= Class.new(FactoryGirl::Evaluator)
    end

    private

    def define_attribute(attribute_name, attribute_proc)
      evaluator_class.send(:define_method, attribute_name) {
        if @cached_attributes.key?(attribute_name)
          @cached_attributes[attribute_name]
        else
          @cached_attributes[attribute_name] = instance_exec(&attribute_proc)
        end
      }
    end
  end
end
