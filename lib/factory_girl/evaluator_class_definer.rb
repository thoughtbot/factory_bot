module FactoryGirl
  class EvaluatorClassDefiner
    def initialize(attributes, callbacks, parent_class)
      @parent_class = parent_class
      @callbacks    = callbacks
      @attributes   = attributes

      attributes.each do |attribute|
        define_attribute(attribute.name, attribute.to_proc)
      end
    end

    def evaluator_class
      @evaluator_class ||= Class.new(@parent_class).tap do |klass|
        klass.callbacks ||= []
        klass.callbacks += @callbacks
        klass.attribute_lists ||= []
        klass.attribute_lists += [@attributes]
      end
    end

    private

    def define_attribute(attribute_name, attribute_proc)
      evaluator_class.send(:define_method, attribute_name) do
        if @cached_attributes.key?(attribute_name)
          @cached_attributes[attribute_name]
        else
          @cached_attributes[attribute_name] = instance_exec(&attribute_proc)
        end
      end
    end
  end
end
