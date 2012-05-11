module FactoryGirl
  # @api private
  class Trait
    attr_reader :name, :definition

    def initialize(name, &block)
      @name = name
      @block = block
      @definition = Definition.new(@name)

      proxy = FactoryGirl::DefinitionProxy.new(@definition)
      proxy.instance_eval(&@block) if block_given?
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
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
