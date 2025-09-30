module FactoryBot
  module Internal
    module Traits
      def self.traits
        @traits ||= Decorator::DisallowsDuplicatesRegistry.new(Registry.new("Trait"))
      end

      def self.reset_traits
        @traits = nil
        traits
      end

      def self.register_trait(trait)
        trait.names.each do |name|
          traits.register(name, trait)
        end
        trait
      end

      def self.trait_by_name(name, klass)
        traits.find(name).tap { |t| t.klass = klass }
      end
    end
  end
end
