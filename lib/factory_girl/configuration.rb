module FactoryGirl
  # @api private
  class Configuration
    attr_reader :factories, :sequences, :traits, :strategies, :callback_names

    def initialize
      @factories      = DisallowsDuplicatesRegistry.new(Registry.new('Factory'))
      @sequences      = DisallowsDuplicatesRegistry.new(Registry.new('Sequence'))
      @traits         = DisallowsDuplicatesRegistry.new(Registry.new('Trait'))
      @strategies     = Registry.new('Strategy')
      @callback_names = Set.new
    end
  end
end
