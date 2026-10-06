require "active_support/core_ext/hash/keys"
require "active_support/inflector"

module FactoryBot
  # @api private
  class Factory
    attr_reader :name, :definition

    def initialize(name, options = {})
      assert_valid_options(options)
      @name = name.respond_to?(:to_sym) ? name.to_sym : name.to_s.underscore.to_sym
      @parent = options[:parent]
      @aliases = options[:aliases] || []
      @class_name = options[:class]
      @uri_manager = FactoryBot::UriManager.new(names)
      @definition = Definition.new(@name, options[:traits] || [], uri_manager: @uri_manager)
      @compiled = false
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
      :defined_traits, :defined_traits_names, :inherit_traits,
      to: :@definition

    def build_class
      @build_class ||= if class_name.is_a? Class
        class_name
      elsif class_name.to_s.safe_constantize
        class_name.to_s.safe_constantize
      else
        class_name.to_s.camelize.constantize
      end
    end

    def run(build_strategy, overrides, &block)
      compiled.run(build_strategy, overrides, &block)
    end

    def human_names
      names.map { |name| name.to_s.humanize.downcase }
    end

    def associations
      compiled.attributes.associations
    end

    # Names for this factory, including aliases.
    #
    # Example:
    #
    #   factory :user, aliases: [:author] do
    #     # ...
    #   end
    #
    #   FactoryBot.create(:author).class
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
    #   FactoryBot.create(:post).author.class
    #   # => User
    def names
      [name] + @aliases
    end

    def compile
      unless @compiled
        parent&.compile
        inherit_parent_traits
        @definition.compile(build_class)
        @compiled = true
      end
    end

    # The parent factory, or nil for a factory without one.
    def parent
      FactoryBot::Internal.factory_by_name(@parent) if @parent
    end

    protected

    def class_name
      @class_name || parent&.class_name || name
    end

    def evaluator_class
      @evaluator_class ||= EvaluatorClassDefiner.new(attributes, parent_evaluator_class).evaluator_class
    end

    def attributes
      compile
      AttributeList.new(@name).tap do |list|
        list.apply_attributes definition.attributes
      end
    end

    def callbacks
      inherited_callbacks + definition.callbacks
    end

    def compiled_to_create
      definition.to_create || inherited_to_create
    end

    def compiled_constructor
      definition.constructor || inherited_constructor
    end

    private

    def assert_valid_options(options)
      options.assert_valid_keys(:class, :parent, :aliases, :traits)
    end

    def compiled
      FactoryBot::Internal.compiled_factory(self, [])
    end

    def parent_evaluator_class
      parent ? parent.evaluator_class : Evaluator
    end

    def inherited_callbacks
      parent ? parent.callbacks : Internal.callbacks
    end

    def inherited_to_create
      parent ? parent.compiled_to_create : Internal.to_create
    end

    def inherited_constructor
      parent ? parent.compiled_constructor : Internal.constructor
    end

    def inherit_parent_traits
      return unless parent

      parent.defined_traits.each do |trait|
        next if defined_traits_names.include?(trait.name)
        define_trait(trait)
      end
    end
  end
end
