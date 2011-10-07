module FactoryGirl
  module Syntax
    module Default
      include Methods

      def define(&block)
        DSL.run(block)
      end

      def modify(&block)
        ModifyDSL.run(block)
      end

      class DSL
        def self.run(block)
          new.instance_eval(&block)
        end

        def factory(name, options = {}, &block)
          factory = Factory.new(name, options)
          proxy = FactoryGirl::DefinitionProxy.new(factory)
          proxy.instance_eval(&block) if block_given?

          FactoryGirl.register_factory(factory)

          proxy.child_factories.each do |(child_name, child_options, child_block)|
            factory(child_name, child_options.merge(:parent => name), &child_block)
          end
        end

        def sequence(name, start_value = 1, &block)
          FactoryGirl.register_sequence(Sequence.new(name, start_value, &block))
        end

        def trait(name, &block)
          FactoryGirl.register_trait(Trait.new(name, &block))
        end
      end

      class ModifyDSL
        def self.run(block)
          new.instance_eval(&block)
        end

        def factory(name, options = {}, &block)
          factory = FactoryGirl.factory_by_name(name).allow_overrides
          proxy = FactoryGirl::DefinitionProxy.new(factory)
          proxy.instance_eval(&block)
          factory.ensure_compiled
        end
      end
    end
  end

  extend Syntax::Default
end
