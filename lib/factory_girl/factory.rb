require "active_support/core_ext/hash/keys"
require "active_support/inflector"

module FactoryGirl
  class Factory
    attr_reader :name, :definition #:nodoc:

    def initialize(name, options = {}) #:nodoc:
      assert_valid_options(options)
      @name             = name.is_a?(Symbol) ? name : name.to_s.underscore.to_sym
      @parent           = options[:parent]
      @aliases          = options[:aliases] || []
      @class_name       = options[:class]
      @definition       = Definition.new(@name, options[:traits] || [])
      @compiled         = false
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait,
             :defined_traits, :inherit_traits, :processing_order, to: :@definition

    def build_class #:nodoc:
      @build_class ||= if class_name.is_a? Class
        class_name
      else
        class_name.to_s.camelize.constantize
      end
    end

    def run(strategy_class, overrides, &block) #:nodoc:
      block ||= lambda {|result| result }
      compile

      strategy = strategy_class.new

      evaluator = evaluator_class.new(strategy, overrides.symbolize_keys)
      attribute_assigner = AttributeAssigner.new(evaluator, &instance_builder)

      strategy.result(attribute_assigner, to_create).tap(&block)
    end

    def human_names
      names.map {|name| name.to_s.humanize.downcase }
    end

    def associations
      evaluator_class.attribute_list.associations
    end

    # Names for this factory, including aliases.
    #
    # Example:
    #
    #   factory :user, aliases: [:author] do
    #     # ...
    #   end
    #
    #   FactoryGirl.create(:author).class
    #   # => User
    #
    # Because an attribute defined without a value or block will build an
    # association with the same name, this allows associations to be defined
    # without factories, such as:
    #
    #   factory :user, aliases: [:author] do
    #     # ...
    #   end
    #
    #   factory :post do
    #     author
    #   end
    #
    #   FactoryGirl.create(:post).author.class
    #   # => User
    def names
      [name] + @aliases
    end

    def compile
      unless @compiled
        parent.compile
        parent.defined_traits.each {|trait| define_trait(trait) }
        @definition.compile
        @compiled = true
      end
    end

    def with_traits(traits)
      self.clone.tap do |factory_with_traits|
        factory_with_traits.inherit_traits traits
      end
    end

    protected

    def class_name #:nodoc:
      @class_name || parent.class_name || name
    end

    def evaluator_class
      @evaluator_class ||= EvaluatorClassDefiner.new(attributes, callbacks, parent.evaluator_class).evaluator_class
    end

    def attributes
      compile
      AttributeList.new(@name).tap do |list|
        processing_order.each do |factory|
          list.apply_attributes factory.attributes
        end
      end
    end

    def callbacks
      processing_order.map {|factory| factory.callbacks }.flatten
    end

    def constructor
      @constructor ||= @definition.constructor || parent.constructor
    end

    private

    def assert_valid_options(options)
      options.assert_valid_keys(:class, :parent, :aliases, :traits)
    end

    def parent
      if @parent
        FactoryGirl.factory_by_name(@parent)
      else
        NullFactory.new
      end
    end

    def instance_builder
      build_class = self.build_class
      constructor || lambda { build_class.new }
    end

    def initialize_copy(source)
      super
      @definition = @definition.clone
      @evaluator_class = nil
    end
  end
end
