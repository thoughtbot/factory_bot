module FactoryGirl
  class Linter
    def self.lint!(factories_to_lint, options)
      new(factories_to_lint, options).lint!
    end

    def initialize(factories_to_lint, options)
      @factories_to_lint = factories_to_lint
      @options = options
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
      factories_to_lint.inject(Hash.new([])) do |result, factory|
        begin
          FactoryGirl.create(factory.name)
        rescue => error
          result[factory] |= [FactoryError.new(error, factory)]
        end

        if @options[:traits]
          factory.definition.defined_traits.map(&:name).each do |trait_name|
            begin
              FactoryGirl.create(factory.name, trait_name)
            rescue => error
              result[factory] |= [FactoryTraitError.new(error, factory, trait_name)]
            end
          end

        end

        result
      end
    end

    def error_message
      lines = invalid_factories.map do |factory, exceptions|
        exceptions.map &:message
      end.flatten

      <<-ERROR_MESSAGE.strip
The following factories are invalid:

#{lines.join("\n")}
      ERROR_MESSAGE
    end
  end

  class FactoryError
    def initialize(wrapped_error, factory)
      @wrapped_error = wrapped_error
      @factory = factory
    end

    def message
      "* #{location} - #{@wrapped_error.message} (#{@wrapped_error.class.name})"
    end

    def location
      @factory.name
    end
  end

  class FactoryTraitError < FactoryError
    def initialize(wrapped_error, factory, trait_name)
      super(wrapped_error, factory)
      @trait_name = trait_name
    end
    def location
      "#{@factory.name}/#{@trait_name}"
    end
  end

end
