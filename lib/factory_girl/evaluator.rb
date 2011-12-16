module FactoryGirl
  class Evaluator
    def initialize(build_strategy, overrides = {}, callbacks = [])
      @build_strategy    = build_strategy
      @overrides         = overrides
      @cached_attributes = overrides

      @build_strategy.add_observer(CallbackRunner.new(callbacks, self))
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

    private

    class CallbackRunner
      def initialize(callbacks, evaluator)
        @callbacks = callbacks
        @evaluator = evaluator
      end

      def update(name, result_instance)
        @callbacks.select {|callback| callback.name == name }.each do |callback|
          callback.run(result_instance, @evaluator)
        end
      end
    end
  end
end
