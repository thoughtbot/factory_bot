module FactoryBot
  class Evaluation
    def initialize(evaluator, attribute_assigner, to_create, callbacks)
      @evaluator = evaluator
      @attribute_assigner = attribute_assigner
      @to_create = to_create
      @callbacks = callbacks
    end

    delegate :object, :hash, to: :@attribute_assigner

    def create(result_instance)
      case @to_create.arity
      when 2 then @to_create[result_instance, @evaluator]
      else @to_create[result_instance]
      end
    end

    def notify(name, result_instance)
      @callbacks.each do |callback|
        callback.run(result_instance, @evaluator) if callback.name == name
      end
    end
  end
end
