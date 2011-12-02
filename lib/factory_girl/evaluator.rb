module FactoryGirl
  class Evaluator
    def initialize(overrides = {})
      @cached_attributes = overrides
    end

    def method_missing(method_name, *args, &block)
      if @cached_attributes.key?(method_name)
        @cached_attributes[method_name]
      else
        super
      end
    end
  end
end
