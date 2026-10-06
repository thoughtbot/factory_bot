module FactoryBot
  # @api private
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new(:null_factory)
    end

    delegate :defined_traits, :attributes, to: :definition

    def compile
    end

    def class_name
    end

    def evaluator_class
      FactoryBot::Evaluator
    end

    def callbacks
      Internal.callbacks
    end

    def compiled_constructor
      Internal.constructor
    end

    def compiled_to_create
      Internal.to_create
    end
  end
end
