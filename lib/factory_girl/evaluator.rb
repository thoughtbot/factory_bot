module FactoryGirl
  class Evaluator
    def initialize(build_strategy, overrides = {})
      @build_strategy    = build_strategy
      @overrides         = overrides.dup
      @cached_attributes = overrides
    end

    delegate :association, :to => :@build_strategy

    def method_missing(method_name, *args, &block)
      if @cached_attributes.key?(method_name)
        @cached_attributes[method_name]
      else
        super
      end
    end
  end
end
