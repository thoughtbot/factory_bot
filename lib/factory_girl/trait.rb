module FactoryGirl
  class Trait
    attr_reader :name

    def initialize(name, &block) #:nodoc:
      @name = name
      @block = block
      @definition = Definition.new

      proxy = FactoryGirl::DefinitionProxy.new(@definition)
      proxy.instance_eval(&@block) if block_given?
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait,
             :callbacks, :attributes, to: :@definition

    def names
      [@name]
    end

    def ==(other)
      name == other.name &&
        block == other.block
    end

    protected
    attr_reader :block
  end
end
