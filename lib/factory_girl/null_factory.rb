module FactoryGirl
  # @api private
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new(:null_factory)
    end

    delegate :defined_traits, :callbacks, :attributes, :constructor,
      :to_create, to: :definition

    def compile; end
    def class_name; end
    def evaluator_class; FactoryGirl::Evaluator; end
    def hierarchy_class; FactoryGirl::DefinitionHierarchy; end
  end
end
