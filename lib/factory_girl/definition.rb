module FactoryGirl
  # @api private
  class Definition
    attr_reader :callbacks, :defined_traits, :declarations, :constructor

    def initialize(name = nil, base_traits = [])
      @declarations      = DeclarationList.new(name)
      @callbacks         = []
      @defined_traits    = []
      @to_create         = ->(instance) { instance.save! }
      @base_traits       = base_traits
      @additional_traits = []
      @constructor       = default_constructor
    end

    delegate :declare_attribute, to: :declarations

    def attributes
      @attributes ||= declarations.attribute_list
    end

    def compile
      attributes
    end

    def processing_order
      base_traits + [self] + additional_traits
    end

    def overridable
      declarations.overridable
      self
    end

    def inherit_traits(new_traits)
      @additional_traits += new_traits
    end

    def add_callback(callback)
      @callbacks << callback
    end

    def to_create(&block)
      if block_given?
        @to_create = block
      else
        @to_create
      end
    end

    def define_trait(trait)
      @defined_traits << trait
    end

    def define_constructor(&block)
      @constructor = block
    end

    def custom_constructor?
      @constructor != default_constructor
    end

    private

    def default_constructor
      @default_constructor ||= -> { new }
    end

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
  end
end
