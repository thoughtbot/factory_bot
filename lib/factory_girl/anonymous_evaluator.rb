module FactoryGirl
  class AnonymousEvaluator
    attr_reader :attributes

    def initialize
      @attributes = []
    end

    def set(attribute, value)
      define_attribute(attribute, value)
      @attributes << attribute
    end

    def set_ignored(attribute, value)
      define_attribute(attribute, value)
    end

    def evaluator
      @evaluator ||= Class.new do
        def initialize
          @cached_attributes = {}
        end
      end
    end

    private

    def define_attribute(attribute, value)
      evaluator.send(:define_method, attribute) {
        @cached_attributes[attribute] ||= instance_exec(&value)
      }
    end
  end
end
