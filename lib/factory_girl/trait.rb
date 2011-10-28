module FactoryGirl
  class Trait
    attr_reader :name

    def initialize(name, &block) #:nodoc:
      @name = name
      @attribute_list = AttributeList.new
      @block = block

      proxy = FactoryGirl::DefinitionProxy.new(self)
      proxy.instance_eval(&@block) if block_given?
    end

    delegate :declare_attribute, :to => :@attribute_list

    def attributes
      @attribute_list.ensure_compiled
      @attribute_list
    end

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
