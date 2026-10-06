module FactoryBot
  # Runs every factory (and optionally every trait) once and reports the ones
  # that raise. Each run is rolled back when ActiveRecord is loaded.
  class Linter
    def initialize(factories, strategy: :create, traits: false, verbose: false)
      @factories = factories
      @strategy = strategy
      @traits = traits
      @verbose = verbose
    end

    def lint!
      errors = @factories.flat_map { |factory| lint(factory) }
      return if errors.empty?

      lines = errors.map { |error| @verbose ? error.verbose_message : error.message }
      raise InvalidFactoryError, "The following factories are invalid:\n\n#{lines.join("\n")}"
    end

    FactoryError = Data.define(:error, :location) do
      def message
        "* #{location} - #{error.message} (#{error.class.name})"
      end

      def verbose_message
        "#{message}\n  #{error.backtrace.join("\n  ")}\n"
      end
    end

    private

    def lint(factory)
      locations = {factory.name.to_s => []}

      if @traits
        Compiler.compile(factory).traits.each_key { |trait| locations["#{factory.name}+#{trait}"] = [trait] }
      end

      locations.filter_map do |location, traits|
        in_transaction { FactoryBot.public_send(@strategy, factory.name, *traits) }
        nil
      rescue => error
        FactoryError.new(error: error, location: location)
      end
    end

    def in_transaction
      if defined?(ActiveRecord::Base)
        ActiveRecord::Base.transaction(joinable: false) do
          yield
          raise ActiveRecord::Rollback
        end
      else
        yield
      end
    end
  end
end
