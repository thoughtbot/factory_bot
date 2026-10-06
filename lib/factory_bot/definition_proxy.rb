module FactoryBot
  # The receiver of a factory, trait or transient block. A blank slate so that
  # any bare word becomes an attribute declaration through method_missing.
  class DefinitionProxy < BasicObject
    attr_reader :child_factories

    def initialize(definition, transient: false, replace: false)
      @definition = definition
      @transient = transient
      @replace = replace
      @child_factories = []
    end

    # `def` inside a block defines a singleton method on this proxy.
    def singleton_method_added(name)
      ::Kernel.raise ::FactoryBot::MethodDefinitionError,
        "Defining methods in blocks (trait or factory) is not supported (#{name})"
    end

    def method_missing(name, *args, &block)
      options = args.first

      if options.nil?
        block ? add_attribute(name, &block) : declare(::FactoryBot::Implicit.new(name: name, transient: @transient))
      elsif options.respond_to?(:key?) && options.key?(:factory)
        association(name, options, &block)
      else
        ::Kernel.raise ::NoMethodError, "undefined method '#{name}' in '#{@definition.name}' factory\n" \
          "Did you mean? '#{name} { #{options.inspect} }'\n"
      end
    end

    def respond_to_missing?(_name, _include_private = false)
      true
    end

    def add_attribute(name, &block)
      declare(::FactoryBot::Attribute.new(name: name, block: block, transient: @transient))
    end

    def transient(&block)
      DefinitionProxy.new(@definition, transient: true, replace: @replace).instance_eval(&block)
    end

    def sequence(name, *args, **options, &block)
      unless name.respond_to?(:to_sym)
        ::Kernel.raise ::ArgumentError, "sequence name must be a Symbol or String, got #{name.inspect}"
      end

      sequence = ::FactoryBot::Sequence.new(name, *args, **options, &block)
      ::FactoryBot.configuration.inline_sequences << sequence
      add_attribute(name) { sequence.next(self) }
    end

    def association(name, *traits_and_overrides, &block)
      if block
        ::Kernel.raise ::FactoryBot::AssociationDefinitionError,
          "Unexpected block passed to '#{name}' association in '#{@definition.name}' factory"
      end

      traits, overrides = ::FactoryBot::Syntax::Methods.split_overrides(traits_and_overrides)
      factory, *factory_traits = ::Kernel.Array(overrides.fetch(:factory, name))

      declare(::FactoryBot::Attribute.new(
        name: name,
        factory: factory,
        traits: factory_traits + traits,
        overrides: overrides.except(:factory)
      ))
    end

    def trait(name, &block)
      @definition.define_trait(::FactoryBot::Trait.build(name, &block), replace: @replace)
    end

    def traits_for_enum(attribute_name, values = nil)
      @definition.enums << ::FactoryBot::Enum.new(attribute_name: attribute_name, values: values)
    end

    def initialize_with(&block)
      @definition.constructor = block
    end

    def to_create(&block)
      @definition.to_create = block
    end

    def skip_create
      @definition.skip_create
    end

    def factory(name, options = {}, &block)
      @child_factories << [name, options, block]
    end

    def before(...) = @definition.before(...)

    def after(...) = @definition.after(...)

    def callback(...) = @definition.callback(...)

    private

    def declare(declaration)
      @definition.declare(declaration, replace: @replace)
    end
  end
end
