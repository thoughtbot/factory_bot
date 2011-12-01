module FactoryGirl
  class AnonymousEvaluator
    attr_reader :attributes

    def initialize
      @attributes = []
    end

    def set(attribute)
      define_attribute(attribute.name, attribute.to_proc)
      @attributes << attribute.name unless attribute.ignored
    end

    def evaluator
      @evaluator ||= Class.new do
        def initialize
          @cached_attributes = {}
        end
      end
    end

    private

    def define_attribute(attribute_name, attribute_proc)
      evaluator.send(:define_method, attribute_name) {
        @cached_attributes[attribute_name] ||= instance_exec(&attribute_proc)
      }
    end
  end
end
