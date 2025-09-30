module FactoryBot
  # @api private
  class Configuration
    attr_reader(
      :callback_names,
      :strategies,
    )

    def initialize
      @strategies = Registry.new("Strategy")
      @callback_names = Set.new
      @definition = Definition.new(:configuration)

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
