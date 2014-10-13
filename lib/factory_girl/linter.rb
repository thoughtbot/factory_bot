module FactoryGirl
  class Linter
    module ErrorList
      attr_accessor :errors
    end

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

    def add_errors(factory, built_factory)
      factory.extend(ErrorList)
      if(built_factory.respond_to?(:errors) && built_factory.errors.respond_to?(:full_messages))
        factory.errors = ": " + built_factory.errors.full_messages.join(', ')
      else
        factory.errors = ""
      end
    end

    def calculate_invalid_factories
      factories_to_lint.select do |factory|
        built_factory = FactoryGirl.build(factory.name)

        if built_factory.respond_to?(:valid?)
          invalid = !built_factory.valid?
          add_errors(factory, built_factory) if(invalid)
          invalid
        end
      end
    end

    def error_message
      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{invalid_factories.map {|factory| "* #{factory.name}#{factory.errors}" }.join("\n")}
      ERROR_MESSAGE
    end
  end
end
