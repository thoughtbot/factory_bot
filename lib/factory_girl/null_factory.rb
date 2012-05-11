module FactoryGirl
  # @api private
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new
    end

    delegate :defined_traits, :callbacks, :attributes, :constructor,
      :compiled_to_create, :compiled_constructor, to: :definition

    def compile; end
    def class_name; end
    def evaluator_class; FactoryGirl::Evaluator; end
  end
end
