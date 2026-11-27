module FactoryBot
  module Internal
    module Definition
      def self.definition
        @definition ||= FactoryBot::Definition.new(:configuration).tap do |definition|
          definition.to_create(&:save!)
          definition.initialize_with { new }
        end
      end

      def self.reset
        @definition = nil
        definition
      end

      class << self
        delegate :to_create,
          :skip_create,
          :constructor,
          :before,
          :after,
          :callback,
          :callbacks,
          :initialize_with,
          to: :definition
      end
    end
  end
end
