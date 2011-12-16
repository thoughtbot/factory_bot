module FactoryGirl
  class Evaluator
    def initialize(build_strategy, overrides = {}, callbacks = [])
      @build_strategy    = build_strategy
      @overrides         = overrides.dup
      @cached_attributes = overrides
      @callbacks         = callbacks
    end

    delegate :association, :to => :@build_strategy

    def method_missing(method_name, *args, &block)
      if @cached_attributes.key?(method_name)
        @cached_attributes[method_name]
      else
        super
      end
    end

    def __overrides
      @overrides
    end

    def update(name, result_instance)
      @callbacks.select {|callback| callback.name == name }.each do |callback|
        callback.run(result_instance, self)
      end
    end
  end
end
