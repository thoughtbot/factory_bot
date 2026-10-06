module FactoryBot
  # Everything FactoryBot.define registers, plus the compiled-factory cache.
  # FactoryBot.reload replaces the whole object.
  class Configuration
    attr_reader :factories, :sequences, :traits, :strategies, :inline_sequences, :definition, :compiled

    def initialize
      @factories = Registry.new("Factory")
      @sequences = Registry.new("Sequence")
      @traits = Registry.new("Trait")
      @strategies = Registry.new("Strategy")
      @inline_sequences = []
      @compiled = {}

      # Global defaults; FactoryBot.define { to_create { } } and friends replace these.
      @definition = Definition.new(:global)
      @definition.constructor = proc { new }
      @definition.to_create = ->(instance) { instance.save! }
    end
  end
end
