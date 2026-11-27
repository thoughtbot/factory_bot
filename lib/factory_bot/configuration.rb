module FactoryBot
  # @api private
  class Configuration
    attr_reader(
      :callback_names,
      :compiled_factories,
      :factories,
      :inline_sequences,
      :sequences,
      :strategies,
      :traits
    )

    def initialize
      @factories = Registry.new("Factory")
      @sequences = Registry.new("Sequence")
      @traits = Registry.new("Trait")
      @strategies = Registry.new("Strategy", replace: true)
      @callback_names = Set.new
      @definition = Definition.new(:configuration)
      @inline_sequences = []
      @compiled_factories = {}

      to_create(&:save!)
      initialize_with { new }
    end

    delegate :to_create, :skip_create, :constructor, :before, :after,
      :callback, :callbacks, to: :@definition

    def initialize_with(&block)
      @definition.define_constructor(&block)
    end
  end
end
