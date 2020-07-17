module FactoryBot
  # @api private
  class Trait
    attr_accessor :factory
    attr_reader :name, :definition

    def initialize(name, &block)
      @name = name.to_s
      @factory = NullFactory.new
      @block = block
      @definition = Definition.new(@name)
      proxy = FactoryBot::DefinitionProxy.new(@definition)

      if block_given?
        proxy.instance_eval(&@block)
      end
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
      :callbacks, to: :@definition

    def names
      [@name]
    end

    def ==(other)
      name == other.name &&
        block == other.block
    end

    def attributes
      AttributeList.new.tap do |attribute_list|
        attribute_lists = aggregate_from_traits_and_self(:attributes) { @definition.declarations.attributes }
        attribute_lists.each do |attributes|
          attribute_list.apply_attributes attributes
        end
      end
    end

    def parent=(factory)
      @factory = factory
    end

    private

    def parent
      @factory || NullFactory.new
    end

    def trait_by_name(name)
      parent.trait_by_name(name) || Internal.trait_by_name(name)
    end

    def base_traits
      @definition.base_traits_.map { |name| trait_by_name(name) }
    end

    def additional_traits
      @definition.additional_traits_.map { |name| trait_by_name(name) }
    end

    def aggregate_from_traits_and_self(method, &block)
      @definition.compile

      [
        base_traits.map(&method),
        instance_exec(&block),
        additional_traits.map(&method)
      ].flatten.compact
    end

    protected

    attr_reader :block
  end
end
