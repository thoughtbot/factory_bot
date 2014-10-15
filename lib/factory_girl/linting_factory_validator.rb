module FactoryGirl
  class LintingFactoryValidator
    def initialize(factory)
      @factory = factory
      @built_factory = FactoryGirl.build(factory.name)
    end

    def valid?
      if built_factory.respond_to?(:valid?)
        built_factory.valid?
      else
        true
      end
    end

    def to_s
      factory.name.to_s
    end

    protected

    attr_reader :factory, :built_factory
  end
end
