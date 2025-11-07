module FactoryBot
  module Syntax
    module Default
      include Methods

      # Each file loaded by factory_bot is expected to call `FactoryBot.define` with a block.
      # The block is evaluated within an instance of `FactoryBot::Syntax::Default::DSL`, giving
      # access to `factory`, `sequence`, `trait`, and other methods.
      #
      # @return [void]
      def define(&block)
        DSL.run(block)
      end

      # Reopens existing factories for extension. When modifying a factory, any of the attributes
      # may be changed aside from callbacks. Callbacks may be added, but will be triggered after
      # the callbacks from the original factory definition.
      #
      # @return [void]
      def modify(&block)
        ModifyDSL.run(block)
      end

      class DSL
        # Defines a Factory
        # @param name [Symbol] the name of the factory
        # @param [Hash] options the options to create a factory with
        # @option options [String|Symbol|Class] :class ({}) The class to construct objects with
        # @option options [Symbol] :parent (nil) The parent factory to inherit from
        # @option options [Symbol[]] :aliases ([]) Alternative names for this factory. Any of these names may be used with a build strategy
        # @option options [Symbol[]] list of traits which are used by default when building this factory
        # @return [void]
        def factory(name, options = {}, &block)
          factory = Factory.new(name, options)
          proxy = FactoryBot::DefinitionProxy.new(factory.definition)
          proxy.instance_eval(&block) if block

          Internal.register_factory(factory)

          proxy.child_factories.each do |(child_name, child_options, child_block)|
            parent_factory = child_options.delete(:parent) || name
            factory(child_name, child_options.merge(parent: parent_factory), &child_block)
          end
        end

        def sequence(name, ...)
          Internal.register_sequence(Sequence.new(name, ...))
        end

        def trait(name, &block)
          Internal.register_trait(Trait.new(name, &block))
        end

        def self.run(block)
          new.instance_eval(&block)
        end

        delegate :after,
          :before,
          :callback,
          :initialize_with,
          :skip_create,
          :to_create,
          to: FactoryBot::Internal
      end

      class ModifyDSL
        def factory(name, _options = {}, &block)
          factory = Internal.factory_by_name(name)
          proxy = FactoryBot::DefinitionProxy.new(factory.definition.overridable)
          proxy.instance_eval(&block)
        end

        def self.run(block)
          new.instance_eval(&block)
        end
      end
    end
  end

  extend Syntax::Default
end
