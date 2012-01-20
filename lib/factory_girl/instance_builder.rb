module FactoryGirl
  class InstanceBuilder
    def initialize(build_class, &constructor)
      @build_class = build_class
      @constructor = constructor
    end

    def build(evaluation_context)
      if @constructor
        evaluation_context.instance_exec(&@constructor)
      else
        @build_class.new
      end
    end
  end
end
