require 'active_support/core_ext/hash/keys'
require 'active_support/inflector'

module FactoryGirl
  # @api private
  class Factory
    attr_reader :name, :definition

    def initialize(name, options = {})
      assert_valid_options(options)
      @name             = name.is_a?(Symbol) ? name : name.to_s.underscore.to_sym
      @parent           = options[:parent]
      @aliases          = options[:aliases] || []
      @class_name       = options[:class]
      @definition       = Definition.new(@name, options[:traits] || [])
      @compiled         = false
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
             :defined_traits, :inherit_traits, :append_traits, :definition_list, to: :@definition

    def build_class
      @build_class ||= if class_name.is_a? Class
        class_name
      else
        class_name.to_s.camelize.constantize
      end
    end

    def run(build_strategy, overrides, &block)
      block ||= ->(result) { result }
      compile

      strategy = StrategyCalculator.new(build_strategy).strategy.new

      evaluator = evaluator_class.new(build_class, strategy, overrides.symbolize_keys)
      attribute_assigner = AttributeAssigner.new(evaluator, build_class, &compiled_constructor)

      evaluation = Evaluation.new(attribute_assigner, compiled_to_create)
      evaluation.add_observer(CallbacksObserver.new(callbacks, evaluator))

      strategy.result(evaluation).tap(&block)
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
        factory_with_traits.append_traits traits
      end
    end

    protected

    def class_name
      @class_name || parent.class_name || name
    end

    def evaluator_class
      @evaluator_class ||= EvaluatorClassDefiner.new(attributes, parent.evaluator_class).evaluator_class
    end

    def attributes
      compile
      AttributeList.new(@name).tap do |list|
        list.apply_attributes definition_list.attributes
      end
    end

    def callbacks
      parent.callbacks + definition_list.callbacks
    end

    def compiled_to_create
      @definition.compiled_to_create || parent.compiled_to_create || FactoryGirl.to_create
    end

    def compiled_constructor
      @definition.compiled_constructor || parent.compiled_constructor || FactoryGirl.constructor
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

    def initialize_copy(source)
      super
      @definition = @definition.clone
      @evaluator_class = nil
    end
  end
end
