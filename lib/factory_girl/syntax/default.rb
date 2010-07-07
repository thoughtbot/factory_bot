module FactoryGirl
  module Syntax
    module Default
      def define(&block)
        DSL.run(block)
      end

      class DSL
        def self.run(block)
          new.instance_eval(&block)
        end

        def factory(name, options = {}, &block)
          factory = Factory.new(name, options)
          proxy = FactoryGirl::DefinitionProxy.new(factory)
          proxy.instance_eval(&block)
          if parent = options.delete(:parent)
            factory.inherit_from(FactoryGirl.factory_by_name(parent))
          end
          FactoryGirl.register_factory(factory)
        end

        def sequence(name, start_value = 1, &block)
          FactoryGirl.sequences[name] = Sequence.new(start_value, &block)
        end
      end
    end
  end

  extend Syntax::Default
end
