require 'pry'
require 'pry-debugger'

module FactoryGirl
  # @api private
  class Definition
    attr_reader :defined_traits, :declarations

    def initialize(name = nil, base_traits = [])
      @declarations      = DeclarationList.new(name)
      @callbacks         = []
      @defined_traits    = []
      @to_create         = nil
      @base_traits       = base_traits
      @additional_traits = []
      @constructor       = nil
      @attributes        = nil
      @compiled          = false
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
        aggregate_from_traits_and_self(:to_create) { @to_create }.last
      end
    end

    def to_create_modules
      compile
      modules = []
      base_traits.each do |trait|
        modules << trait.to_create_modules
      end

      if @to_create
        mod = Module.new
        tc = @to_create

        mod.send :define_method, :to_create do
          tc
        end

        modules << mod
      end

      additional_traits.each do |trait|
        modules << trait.to_create_modules
      end

      modules.compact.flatten
    end

    def modules
      compile
      mods = []
      base_traits.each do |trait|
        mods << trait.modules
      end

      if @constructor
        mod = Module.new
        tc = @constructor

        mod.send :define_method, :constructor do
          tc
        end

        mods << mod
      end

      if @callbacks.any?
        mod = Module.new
        callbacks = @callbacks

        mod.send :define_method, :callbacks do
          super() + callbacks
        end

        mods << mod
      end

      if @to_create
        mod = Module.new
        tc = @to_create

        mod.send :define_method, :to_create do
          tc
        end

        mods << mod
      end

      additional_traits.each do |trait|
        mods << trait.modules
      end
      mods.compact.flatten
      # [constructor_modules + callback_modules + to_create_modules].compact.flatten
    end

    def constructor_modules
      compile
      modules = []
      base_traits.each do |trait|
        modules << trait.constructor_modules
      end

      if @constructor
        mod = Module.new
        tc = @constructor

        mod.send :define_method, :constructor do
          tc
        end

        modules << mod
      end

      additional_traits.each do |trait|
        modules << trait.constructor_modules
      end

      modules.compact.flatten
    end

    def callback_modules
      compile
      modules = []
      base_traits.each do |trait|
        modules << trait.callback_modules
      end

      if @callbacks.any?
        mod = Module.new
        callbacks = @callbacks

        mod.send :define_method, :callbacks do
          super() + callbacks
        end

        modules << mod
      end

      additional_traits.each do |trait|
        modules << trait.callback_modules
      end

      modules.compact.flatten
    end

    def constructor
      aggregate_from_traits_and_self(:constructor) { @constructor }.last
    end

    def callbacks
      aggregate_from_traits_and_self(:callbacks) { @callbacks }
    end

    def compile
      unless @compiled
        declarations.attributes

        defined_traits.each do |defined_trait|
          base_traits.each       {|bt| bt.define_trait defined_trait }
          additional_traits.each {|bt| bt.define_trait defined_trait }
        end

        @compiled = true
      end
    end

    def overridable
      declarations.overridable
      self
    end

    def inherit_traits(new_traits)
      @base_traits += new_traits
    end

    def append_traits(new_traits)
      @additional_traits += new_traits
    end

    def add_callback(callback)
      @callbacks << callback
    end

    def skip_create
      @to_create = ->(instance) { }
    end

    def define_trait(trait)
      @defined_traits << trait
    end

    def define_constructor(&block)
      @constructor = block
    end

    def before(*names, &block)
      callback(*names.map {|name| "before_#{name}" }, &block)
    end

    def after(*names, &block)
      callback(*names.map {|name| "after_#{name}" }, &block)
    end

    def callback(*names, &block)
      names.each do |name|
        FactoryGirl.register_callback(name)
        add_callback(Callback.new(name, block))
      end
    end

    private

    def base_traits
      @base_traits.map { |name| trait_by_name(name) }
    end

    def additional_traits
      @additional_traits.map { |name| trait_by_name(name) }
    end

    def trait_by_name(name)
      trait_for(name) || FactoryGirl.trait_by_name(name)
    end

    def trait_for(name)
      defined_traits.detect {|trait| trait.name == name }
    end

    def initialize_copy(source)
      super
      @attributes = nil
      @compiled   = false
    end

    def aggregate_from_traits_and_self(method_name, &block)
      compile
      [].tap do |list|
        base_traits.each do |trait|
          list << trait.send(method_name)
        end

        list << instance_exec(&block)

        additional_traits.each do |trait|
          list << trait.send(method_name)
        end
      end.flatten.compact
    end
  end
end
