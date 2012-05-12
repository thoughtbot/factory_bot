module FactoryGirl
  # @api private
  class Definition
    attr_reader :callbacks, :defined_traits, :declarations, :constructor

    def initialize(name = nil, base_traits = [])
      @declarations      = DeclarationList.new(name)
      @callbacks         = []
      @defined_traits    = []
      @to_create         = nil
      @base_traits       = base_traits
      @additional_traits = []
      @constructor       = nil
    end

    delegate :declare_attribute, to: :declarations

    def attributes
      @attributes ||= declarations.attribute_list
    end

    def compile
      attributes
    end

    def definition_list
      DefinitionList.new(
        base_traits.map(&:definition) + [self] + additional_traits.map(&:definition)
      )
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

    def compiled_to_create
      definition_list.to_create
    end

    def compiled_constructor
      definition_list.constructor
    end

    def to_create(&block)
      if block_given?
        @to_create = block
      else
        @to_create
      end
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
  end
end
