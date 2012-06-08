module FactoryGirl
  # @api private
  class Configuration
    attr_reader :factories, :sequences, :traits, :strategies, :callback_names

    attr_accessor :duplicate_attribute_assignment_from_initialize_with

    def initialize
      @factories      = Decorator::DisallowsDuplicatesRegistry.new(Registry.new('Factory'))
      @sequences      = Decorator::DisallowsDuplicatesRegistry.new(Registry.new('Sequence'))
      @traits         = Decorator::DisallowsDuplicatesRegistry.new(Registry.new('Trait'))
      @strategies     = Registry.new('Strategy')
      @callback_names = Set.new
      @definition     = Definition.new

      @duplicate_attribute_assignment_from_initialize_with = true

      to_create {|instance| instance.save! }
      initialize_with { new }
    end

    delegate :to_create, :skip_create, :constructor, to: :@definition

    def initialize_with(&block)
      @definition.define_constructor(&block)
    end
  end
end
