module FactoryBot
  # @api private
  class Definition
    attr_reader :base_traits, :callbacks, :constructor, :defined_traits, :declarations, :name,
      :registered_enums, :uri_manager
    attr_accessor :klass

    def initialize(name, base_traits = [], **opts)
      @name = name
      @uri_manager = opts[:uri_manager]
      @declarations = DeclarationList.new(name)
      @callbacks = []
      @defined_traits = Set.new
      @registered_enums = []
      @to_create = nil
      @base_traits = base_traits
      @constructor = nil
    end

    delegate :declare_attribute, to: :declarations

    def to_create(&block)
      if block
        @to_create = block
      else
        @to_create
      end
    end

    def overridable
      declarations.overridable
      self
    end

    def inherit_traits(new_traits)
      @base_traits |= new_traits
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
