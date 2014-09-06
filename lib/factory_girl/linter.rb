module FactoryGirl
  class Linter
    def self.lint!(factories_to_lint)
      new(factories_to_lint).lint!
    end

    def initialize(factories_to_lint)
      @factories_to_lint = factories_to_lint
      @invalid_factory_messages = calculate_invalid_factory_messages
    end

    def lint!
      if invalid_factory_messages.any?
        raise InvalidFactoryError, error_message
      end
    end

    private

    attr_reader :factories_to_lint, :invalid_factory_messages

    def calculate_invalid_factory_messages
      factories_to_lint.map do |factory|
        built_factory = FactoryGirl.build(factory.name)

        if built_factory.respond_to?(:valid?) && !built_factory.valid?
          "* #{factory.name} -- #{built_factory.errors.full_messages.join('; ')}"
        end
      end.compact
    end

    def error_message
      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{invalid_factory_messages.join("\n")}
      ERROR_MESSAGE
    end
  end
end
