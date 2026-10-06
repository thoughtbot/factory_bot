module FactoryBot
  # Extended into FactoryBot: `FactoryBot.define` and `FactoryBot.modify`.
  module DSL
    def define(&block)
      Definer.new.instance_eval(&block)
      configuration.compiled.clear
    end

    def modify(&block)
      Modifier.new.instance_eval(&block)
      configuration.compiled.clear
    end

    # The receiver of a FactoryBot.define block.
    class Definer
      def factory(name, options = {}, &block)
        factory = Factory.new(name, options)
        proxy = DefinitionProxy.new(factory.definition)
        proxy.instance_eval(&block) if block

        factory.names.each { |factory_name| FactoryBot.factories.register(factory_name, factory) }

        proxy.child_factories.each do |child_name, child_options, child_block|
          factory(child_name, {parent: name}.merge(child_options), &child_block)
        end
      end

      def sequence(name, *args, **options, &block)
        sequence = Sequence.new(name, *args, **options, &block)
        sequence.names.each { |sequence_name| FactoryBot.sequences.register(sequence_name, sequence) }
      end

      def trait(name, &block)
        trait = Trait.build(name, &block)
        FactoryBot.traits.register(trait.name, trait)
      end

      def before(...) = global.before(...)

      def after(...) = global.after(...)

      def callback(...) = global.callback(...)

      def initialize_with(&block)
        global.constructor = block
      end

      def to_create(&block)
        global.to_create = block
      end

      def skip_create
        global.skip_create
      end

      private

      def global
        FactoryBot.configuration.definition
      end
    end

    # The receiver of a FactoryBot.modify block.
    class Modifier
      def factory(name, _options = {}, &block)
        factory = FactoryBot.factories.find(name)
        DefinitionProxy.new(factory.definition, replace: true).instance_eval(&block) if block
      end
    end
  end
end
