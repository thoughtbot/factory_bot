module FactoryGirl
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new
    end

    delegate :defined_traits, :callbacks, :attributes, :to => :definition

    def compile; end
    def default_strategy; end
    def class_name; end
  end
end
