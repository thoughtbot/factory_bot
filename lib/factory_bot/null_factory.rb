module FactoryBot
  # @api private
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new(:null_factory)
    end

    delegate :defined_traits, to: :definition

    def compile
    end

    def class_name
    end

    def compiled(_trait_names = [])
      CompiledFactory.new(
        build_class: nil,
        evaluator_class: FactoryBot::Evaluator,
        callbacks: Internal.callbacks,
        constructor: Internal.constructor,
        to_create: Internal.to_create
      )
    end
  end
end
