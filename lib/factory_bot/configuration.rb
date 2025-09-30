module FactoryBot
  # @api private
  class Configuration
    def initialize
      @definition = Definition.new(:configuration)

      to_create(&:save!)
      initialize_with { new }
    end

    delegate :to_create,
      :skip_create,
      :constructor,
      :before,
      :after,
      :callback,
      :callbacks,
      :initialize_with,
      to: :@definition
  end
end
