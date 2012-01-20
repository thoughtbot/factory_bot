module FactoryGirl
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new
    end

    delegate :defined_traits, :callbacks, :attributes, :constructor, :to => :definition

    def compile; end
    def class_name; end
    def default_strategy; :create; end
    def evaluator_class; FactoryGirl::Evaluator; end
  end
end
