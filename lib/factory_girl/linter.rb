module FactoryGirl
  class Linter
    def self.lint!(factories_to_lint)
      new(factories_to_lint).lint!
    end

    def initialize(factories_to_lint)
      @factories_to_lint = factories_to_lint.map do |factory|
        ErroringModel.new(factory)
      end

      @invalid_factories = calculate_invalid_factories
    end

    def lint!
      if invalid_factories.any?
        raise InvalidFactoryError, error_message
      end
    end

    private

    attr_reader :factories_to_lint, :invalid_factories

    def calculate_invalid_factories
      factories_to_lint.reject(&:valid?)
    end

    def error_message
      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{invalid_factories.map {|factory| "* #{factory.name}: #{factory.errors}" }.join("\n")}
      ERROR_MESSAGE
    end

    class ErroringModel
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

      def errors
        error_list.to_sentence
      end

      def name
        factory.name
      end

      protected

      attr_reader :factory, :built_factory

      def error_list
        if built_factory.respond_to?(:errors) && built_factory.errors.respond_to?(:full_messages)
          built_factory.errors.full_messages
        else
          []
        end
      end
    end

  end
end
