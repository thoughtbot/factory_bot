module FactoryBot
  class Factory
    attr_reader :name, :aliases, :parent_name, :definition

    def initialize(name, options = {})
      options.assert_valid_keys(:class, :parent, :aliases, :traits)
      @name = name.to_sym
      @aliases = Array(options[:aliases]).map(&:to_sym)
      @class_name = options[:class]
      @parent_name = options[:parent]&.to_sym
      @definition = Definition.new(@name, base_trait_names: Array(options[:traits]))
    end

    def names
      [name, *aliases]
    end

    # Looked up lazily so a child can be defined before its parent.
    def parent
      parent_name && FactoryBot.factories.find(parent_name)
    end

    def class_name
      @class_name || parent&.class_name || name
    end

    def build_class
      @build_class ||= if class_name.is_a?(Class)
        class_name
      else
        class_name.to_s.safe_constantize || class_name.to_s.camelize.constantize
      end
    end
  end
end
