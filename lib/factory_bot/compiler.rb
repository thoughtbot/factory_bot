module FactoryBot
  # Turns a Factory plus runtime traits into a CompiledFactory. This is the one
  # place that decides precedence:
  #
  #   attributes:  parent < base traits < own declarations < runtime traits
  #   callbacks:   global, parent chain, base traits, own, runtime traits
  #   constructor and to_create: runtime traits, own, base traits, parent, global
  #   trait lookup: own traits, parent chain, enum traits, global traits
  class Compiler
    Part = Data.define(:attributes, :callbacks, :constructor, :to_create)

    def self.compile(factory, runtime_traits = [])
      names = runtime_traits.map(&:to_s)
      FactoryBot.configuration.compiled[[factory.name, names]] ||= new(factory, names).compile
    end

    def initialize(factory, runtime_trait_names)
      @factory = factory
      @runtime_trait_names = runtime_trait_names
      @parent = factory.parent && Compiler.compile(factory.parent)
      @build_class = factory.build_class
      @scope = trait_scope
      @parts = {}
      @compiling = []
    end

    def compile
      own = compile_definition(@factory.definition, @scope)
      runtime = @runtime_trait_names.map { |name| compile_trait(find_trait(name, @scope)) }
      global = FactoryBot.configuration.definition

      CompiledFactory.new(
        factory: @factory,
        build_class: @build_class,
        attributes: [@parent&.attributes || {}, own.attributes, *runtime.map(&:attributes)].reduce(:merge).freeze,
        callbacks: (inherited_callbacks(global) + own.callbacks + runtime.flat_map(&:callbacks)).uniq.freeze,
        constructor: runtime.filter_map(&:constructor).last || own.constructor || @parent&.constructor || global.constructor,
        to_create: runtime.filter_map(&:to_create).last || own.to_create || @parent&.to_create || global.to_create,
        traits: @scope.freeze
      )
    end

    private

    def inherited_callbacks(global)
      @parent ? @parent.callbacks : global.callbacks
    end

    def trait_scope
      enum_traits = enums.flat_map { |enum| enum.traits(@build_class) }.to_h { |trait| [trait.name, trait] }
      enum_traits.merge(@parent&.traits || {}).merge(@factory.definition.traits)
    end

    def enums
      automatic =
        if FactoryBot.automatically_define_enum_traits && @build_class.respond_to?(:defined_enums)
          @build_class.defined_enums.keys.map { |name| Enum.new(attribute_name: name, values: nil) }
        else
          []
        end

      automatic + @factory.definition.enums
    end

    def find_trait(name, scope, within: nil)
      scope.fetch(name.to_s) { FactoryBot.traits.find(name) }
    rescue KeyError => error
      raise unless within

      raise KeyError.new("#{error.message} referenced within \"#{within}\" definition",
        receiver: error.receiver, key: error.key)
    end

    def compile_trait(trait)
      if @compiling.include?(trait)
        raise TraitDefinitionError, "Circular trait reference: #{[*@compiling, trait].map(&:name).join(" -> ")}"
      end

      @parts[trait] ||= begin
        @compiling.push(trait)
        compile_definition(trait.definition, @scope.merge(trait.definition.traits))
      ensure
        @compiling.pop
      end
    end

    def compile_definition(definition, scope)
      payload = {name: definition.name, class: @build_class, traits: @factory.definition.traits.values}

      ActiveSupport::Notifications.instrument("factory_bot.compile_factory", payload) do
        base_names = definition.base_trait_names.dup
        declared = {}

        definition.declarations.each do |declaration|
          attribute = resolve(declaration, definition, base_names)
          next unless attribute

          if declared.key?(attribute.name)
            raise AttributeDefinitionError, "Attribute already defined: #{attribute.name}"
          end

          declared[attribute.name] = attribute
        end

        payload[:attributes] = declared.values
        base = base_names.map { |name| compile_trait(find_trait(name, scope, within: definition.name)) }

        Part.new(
          attributes: base.map(&:attributes).reduce({}, :merge).merge(declared),
          callbacks: base.flat_map(&:callbacks) + definition.callbacks,
          constructor: definition.constructor || base.filter_map(&:constructor).last,
          to_create: definition.to_create || base.filter_map(&:to_create).last
        )
      end
    end

    # Resolves a declaration to an Attribute, or to nil when the bare word
    # names a trait (which becomes one of the definition's base traits).
    def resolve(declaration, definition, base_names)
      case declaration
      when Attribute
        declaration.association? ? check_association!(declaration, definition) : declaration
      when Implicit
        name = declaration.name

        if FactoryBot.factories.registered?(name)
          check_association!(Attribute.new(name: name, factory: name), definition)
        elsif FactoryBot.sequences.registered?(name)
          Attribute.new(name: name, transient: declaration.transient, block: -> { FactoryBot.generate(name) })
        elsif name.to_s == definition.name.to_s
          raise TraitDefinitionError, "Self-referencing trait '#{name}'"
        else
          base_names << name.to_s
          nil
        end
      end
    end

    def check_association!(attribute, definition)
      factory = attribute.factory

      if declaration?(factory)
        raise ArgumentError, "Association '#{attribute.name}' received an invalid factory argument.\n" \
          "Did you mean? 'factory: :#{factory.name}'\n"
      end

      attribute.overrides.each do |key, value|
        if declaration?(value)
          raise ArgumentError, "Association '#{attribute.name}' received an invalid attribute override.\n" \
            "Did you mean? '#{key}: :#{value.name}'\n"
        end
      end

      if factory.to_s == definition.name.to_s
        raise AssociationDefinitionError, "Self-referencing association '#{attribute.name}' in '#{definition.name}'"
      end

      attribute
    end

    def declaration?(value)
      value.is_a?(Implicit) || value.is_a?(Attribute)
    end
  end
end
