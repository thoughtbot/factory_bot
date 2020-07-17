module FactoryBot
  # @api private
  class Definition
    attr_reader :traits, :declarations, :name, :registered_enums, :base_traits_, :additional_traits_

    def initialize(name, base_traits = [])
      @name = name
      @declarations = DeclarationList.new(name)
      @callbacks = []
      @traits = ActiveSupport::HashWithIndifferentAccess.new
      @registered_enums = []
      @to_create = nil
      @base_traits_ = base_traits
      @additional_traits_ = []
      @constructor = nil
      @attributes = nil
      @compiled = false
      @expanded_enum_traits = false
    end

    delegate :declare_attribute, to: :declarations

    def attributes
      @attributes ||= AttributeList.new.tap do |attribute_list|
        attribute_lists = aggregate_from_traits_and_self(:attributes) { declarations.attributes }
        attribute_lists.each do |attributes|
          attribute_list.apply_attributes attributes
        end
      end
    end

    def to_create(&block)
      if block_given?
        @to_create = block
      else
        # aggregate_from_traits_and_self(:to_create) { @to_create }.last
        @to_create
      end
    end

    def constructor
      # aggregate_from_traits_and_self(:constructor) { @constructor }.last
      @constructor
    end

    def callbacks
      # aggregate_from_traits_and_self(:callbacks) { @callbacks }
      @callbacks
    end

    def compile(klass = nil)
      unless @compiled
        expand_enum_traits(klass) unless klass.nil?

        declarations.attributes

        @compiled = true
      end
    end

    def overridable
      declarations.overridable
      self
    end

    def inherit_traits(new_traits)
      @base_traits_ += new_traits
    end

    def append_traits(new_traits)
      @additional_traits_ += new_traits
    end

    def add_callback(callback)
      @callbacks << callback
    end

    def skip_create
      @to_create = ->(instance) {}
    end

    def define_trait(trait)
      @traits[trait.name] = trait unless @traits.key?(trait.name)
    end

    def register_enum(enum)
      @registered_enums << enum
    end

    def define_constructor(&block)
      @constructor = block
    end

    def before(*names, &block)
      callback(*names.map { |name| "before_#{name}" }, &block)
    end

    def after(*names, &block)
      callback(*names.map { |name| "after_#{name}" }, &block)
    end

    def callback(*names, &block)
      names.each do |name|
        add_callback(Callback.new(name, block))
      end
    end

    private

    def base_traits
      @base_traits_.map { |name| trait_by_name(name) }
    end

    def additional_traits
      @additional_traits_.map { |name| trait_by_name(name) }
    end

    def trait_by_name(name)
      @traits[name] || Internal.trait_by_name(name)
    end

    def initialize_copy(source)
      super
      @attributes = nil
      @compiled = false
    end

    def aggregate_from_traits_and_self(method_name, &block)
      compile

      [
        base_traits.map(&method_name),
        instance_exec(&block),
        additional_traits.map(&method_name)
      ].flatten.compact
    end

    def expand_enum_traits(klass)
      return if @expanded_enum_traits

      if automatically_register_defined_enums?(klass)
        automatically_register_defined_enums(klass)
      end

      registered_enums.each do |enum|
        traits = enum.build_traits(klass)
        traits.each { |trait| define_trait(trait) }
      end

      @expanded_enum_traits = true
    end

    def automatically_register_defined_enums(klass)
      klass.defined_enums.each_key { |name| register_enum(Enum.new(name)) }
    end

    def automatically_register_defined_enums?(klass)
      FactoryBot.automatically_define_enum_traits &&
        klass.respond_to?(:defined_enums)
    end
  end
end
