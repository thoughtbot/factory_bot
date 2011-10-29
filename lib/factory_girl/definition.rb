module FactoryGirl
  class Definition
    attr_reader :callbacks, :defined_traits, :attribute_list

    def initialize(name = nil)
      @attribute_list = AttributeList.new(name)
      @callbacks      = []
      @defined_traits = []
      @to_create      = nil
      @traits         = []
    end

    delegate :declare_attribute, :to => :attribute_list

    def traits
      @traits.reverse.map { |name| trait_by_name(name) }
    end

    def inherit_traits(new_traits)
      @traits += new_traits
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

    private

    def trait_by_name(name)
      trait_for(name) || FactoryGirl.trait_by_name(name)
    end

    def trait_for(name)
      defined_traits.detect {|trait| trait.name == name }
    end
  end
end
