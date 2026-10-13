module FactoryBot
  # What a factory or trait block declared, as data. Compiler resolves it.
  # @api private
  class Definition
    attr_reader :base_traits, :callbacks, :constructor, :declarations, :defined_traits,
      :name, :registered_enums, :uri_manager

    def initialize(name, base_traits = [], **opts)
      @name = name
      @uri_manager = opts[:uri_manager]
      @declarations = []
      @overridable = false
      @callbacks = []
      @defined_traits = Set.new
      @registered_enums = []
      @to_create = nil
      @base_traits = base_traits
      @constructor = nil
    end

    def declare_attribute(declaration)
      if @overridable
        @declarations.delete_if { |existing| existing.name == declaration.name }
      end

      @declarations << declaration
      declaration
    end

    # After this, redeclaring an attribute replaces it, as FactoryBot.modify needs.
    def overridable
      @overridable = true
      self
    end

    def to_create(&block)
      if block
        @to_create = block
      else
        @to_create
      end
    end

    def add_callback(callback)
      @callbacks << callback
    end

    def skip_create
      @to_create = ->(instance) {}
    end

    def define_trait(trait)
      @defined_traits.add(trait)
    end

    def defined_traits_names
      @defined_traits.map(&:name)
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
  end
end
