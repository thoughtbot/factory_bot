module FactoryGirl
  class FactoryLinter
    def initialize(factory)
      @factory = factory
      @built_factory = FactoryGirl.build(factory.name)
    end

    attr_reader :factory, :generated_factory

    def valid?
      if generated_factory.respond_to?(:valid?)
        generated_factory.valid?
      else
        true
      end
    end

    def to_s
      factory.name.to_s
    end
  end
end
