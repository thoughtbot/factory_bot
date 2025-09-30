module FactoryBot
  module Internal
    module Factories
      def self.factories
        @factories ||= Decorator::DisallowsDuplicatesRegistry.new(Registry.new("Factory"))
      end

      def self.reset
        @factories = nil
        factories
      end

      def self.register_factory(factory)
        factory.names.each do |name|
          factories.register(name, factory)
        end
        factory
      end

      def self.factory_by_name(name)
        factories.find(name)
      end
    end
  end
end
