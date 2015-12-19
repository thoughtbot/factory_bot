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

    attr_reader :factories_to_lint, :invalid_factories
    private     :factories_to_lint, :invalid_factories

    private

    def calculate_invalid_factories
      factories_to_lint.inject({}) do |result, factory|
        begin
          name = factory.name
          FactoryGirl.create(factory.name)
          factory.defined_traits.each do |trait|
            name = "#{factory.name} with trait: #{trait.name}"
            FactoryGirl.create(factory.name, trait.name)
          end
        rescue => error
          result[name] = error
        end

        result
      end
    end

    def error_message
      lines = invalid_factories.map do |factory_name, exception|
        "* #{factory_name} - #{exception.message} (#{exception.class.name})"
      end

      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{lines.join("\n")}
      ERROR_MESSAGE
    end
  end
end
