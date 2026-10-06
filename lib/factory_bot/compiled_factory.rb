module FactoryBot
  # Everything a run needs from a factory and a list of traits, resolved once
  # and cached by the configuration.
  # @api private
  class CompiledFactory
    attr_reader :build_class, :attributes, :association_names, :callbacks, :constructor, :to_create

    def initialize(build_class:, attributes:, callbacks:, constructor:, to_create:, association_names: [])
      @build_class = build_class
      @attributes = attributes
      @association_names = association_names
      @callbacks = callbacks
      @constructor = constructor
      @to_create = to_create
    end

    def run(build_strategy, overrides, &block)
      block ||= ->(result) { result }

      strategy = Strategy.lookup_strategy(build_strategy).new

      evaluator = Evaluator.new(self, strategy, overrides.symbolize_keys)
      attribute_assigner = AttributeAssigner.new(evaluator, attributes, association_names, &constructor)
      evaluation = Evaluation.new(evaluator, attribute_assigner, to_create, callbacks)

      evaluation.notify(:before_all, nil)
      instance = strategy.result(evaluation).tap(&block)
      evaluation.notify(:after_all, instance)

      instance
    end

    def associations
      attributes.values.select(&:association?)
    end
  end
end
