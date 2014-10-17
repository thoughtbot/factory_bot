module FactoryGirl
  class Linter
    def self.lint!(factories_to_lint)
      new(factories_to_lint).lint!
    end

    def initialize(factories_to_lint)
      @factories_to_lint = factories_to_lint
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
      factories_to_lint.inject({}) do |result, factory|
        begin
          FactoryGirl.create(factory.name)
        rescue => error
          result[factory] = error
        end

        result
      end
    end

    def error_message
      lines = invalid_factories.map do |factory, exception|
        "* #{factory.name} - #{exception.message} (#{exception.class.name})"
      end

      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{lines.join("\n")}
      ERROR_MESSAGE
    end
  end
end
