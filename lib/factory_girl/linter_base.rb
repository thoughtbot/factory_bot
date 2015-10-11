module FactoryGirl
  class LinterBase
    def self.lint!(factories_to_lint)
      new(factories_to_lint).lint!
    end

    def lint!
      if invalid_factories.any?
        raise InvalidFactoryError, error_message
      end
    end

    def initialize(factories_to_lint)
      @factories_to_lint = factories_to_lint
      @invalid_factories = calculate_invalid_factories
    end

    attr_reader :factories_to_lint, :invalid_factories
    private :factories_to_lint, :invalid_factories

    class FactoryError
      def initialize(wrapped_error, factory)
        @wrapped_error = wrapped_error
        @factory       = factory
      end

      def message
        message = @wrapped_error.message
        "* #{location} - #{message} (#{@wrapped_error.class.name})"
      end

      def location
        @factory.name
      end
    end

    def error_message
      lines = invalid_factories.map do |_factory, exceptions|
        exceptions.map &:message
      end.flatten

      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{lines.join("\n")}
      ERROR_MESSAGE
    end
  end
end
