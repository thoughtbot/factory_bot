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
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
      :defined_traits, to: :@definition

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
      compiled.associations
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

    # The cached snapshot for this factory with the given traits applied.
    def compiled(trait_names = [])
      Internal.compiled_factory(self, trait_names)
    end

    def compile_with_traits(trait_names)
      Compiler.new(self, trait_names).compile
    end

    def parent
      if @parent
        FactoryBot::Internal.factory_by_name(@parent)
      else
        NullFactory.new
      end
    end

    protected

    def class_name
      @class_name || parent.class_name || name
    end

    private

    def assert_valid_options(options)
      options.assert_valid_keys(:class, :parent, :aliases, :traits)
    end
  end
end
