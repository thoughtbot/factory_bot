module FactoryGirl
  # Raised when a factory is defined that attempts to instantiate itself.
  class AssociationDefinitionError < RuntimeError
  end

  # Raised when a callback is defined that has an invalid name
  class InvalidCallbackNameError < RuntimeError
  end

  # Raised when a factory is defined with the same name as a previously-defined factory.
  class DuplicateDefinitionError < RuntimeError
  end

  class Factory
    attr_reader :name #:nodoc:
    attr_reader :traits #:nodoc:

    def factory_name
      puts "WARNING: factory.factory_name is deprecated. Use factory.name instead."
      name
    end

    def class_name #:nodoc:
      @options[:class] || name
    end

    def build_class #:nodoc:
      @build_class ||= class_for(class_name)
    end

    def default_strategy #:nodoc:
      @options[:default_strategy] || :create
    end

    def initialize(name, options = {}) #:nodoc:
      assert_valid_options(options)
      @name                     = factory_name_for(name)
      @parent                   = options[:parent]
      @options                  = options
      @traits                   = []
      @children                 = []
      @attribute_list           = AttributeList.new
      @inherited_attribute_list = AttributeList.new
    end

    def allow_overrides
      @attribute_list.overridable
      @inherited_attribute_list.overridable
      self
    end

    def allow_overrides?
      @attribute_list.overridable?
    end

    def inherit_from(parent) #:nodoc:
      @options[:class]            ||= parent.class_name
      @options[:default_strategy] ||= parent.default_strategy

      allow_overrides if parent.allow_overrides?
      parent.add_child(self)

      @inherited_attribute_list.apply_attributes(parent.attributes)
    end

    def add_child(factory)
      @children << factory unless @children.include?(factory)
    end

    def apply_traits(traits) #:nodoc:
      traits.reverse.map { |name| trait_by_name(name) }.each do |trait|
        apply_attributes(trait.attributes)
      end
    end

    def apply_attributes(attributes_to_apply)
      @attribute_list.apply_attributes(attributes_to_apply)
    end

    def define_attribute(attribute)
      if attribute.respond_to?(:factory) && attribute.factory == self.name
        raise AssociationDefinitionError, "Self-referencing association '#{attribute.name}' in factory '#{self.name}'"
      end

      @attribute_list.define_attribute(attribute).tap { update_children }
    end

    def define_trait(trait)
      @traits << trait
    end

    def add_callback(name, &block)
      @attribute_list.add_callback(name, &block)
    end

    def attributes
      AttributeList.new.tap do |list|
        list.apply_attributes(@attribute_list)
        list.apply_attributes(@inherited_attribute_list)
      end.to_a
    end

    def run(proxy_class, overrides) #:nodoc:
      proxy = proxy_class.new(build_class)
      overrides = symbolize_keys(overrides)

      attributes.each do |attribute|
        factory_overrides = overrides.select { |attr, val| attribute.aliases_for?(attr) }
        if factory_overrides.empty?
          attribute.add_to(proxy)
        else
          factory_overrides.each { |attr, val| proxy.set(attr, val, attribute.ignored); overrides.delete(attr) }
        end
      end
      overrides.each { |attr, val| proxy.set(attr, val) }
      proxy.result(@to_create_block)
    end

    def human_names
      names.map {|name| name.to_s.gsub('_', ' ') }
    end

    def associations
      attributes.select {|attribute| attribute.association? }
    end

    def trait_by_name(name)
      if existing_attribute = trait_for(name)
        existing_attribute
      elsif @parent
        FactoryGirl.factory_by_name(@parent).trait_by_name(name)
      else
        FactoryGirl.trait_by_name(name)
      end
    end

    # Names for this factory, including aliases.
    #
    # Example:
    #
    #   factory :user, :aliases => [:author] do
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
    #   factory :user, :aliases => [:author] do
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
      [name] + (@options[:aliases] || [])
    end

    def to_create(&block)
      @to_create_block = block
    end

    private

    def update_children
      @children.each { |child| child.inherit_from(self) }
    end

    def class_for (class_or_to_s)
      if class_or_to_s.respond_to?(:to_sym)
        class_name = variable_name_to_class_name(class_or_to_s)
        class_name.split('::').inject(Object) do |object, string|
          object.const_get(string)
        end
      else
        class_or_to_s
      end
    end

    def factory_name_for(class_or_to_s)
      if class_or_to_s.respond_to?(:to_sym)
        class_or_to_s.to_sym
      else
        class_name_to_variable_name(class_or_to_s).to_sym
      end
    end

    def assert_valid_options(options)
      invalid_keys = options.keys - [:class, :parent, :default_strategy, :aliases, :traits]
      unless invalid_keys == []
        raise ArgumentError, "Unknown arguments: #{invalid_keys.inspect}"
      end
      if options[:default_strategy]
        assert_valid_strategy(options[:default_strategy])
        puts "WARNING: default_strategy is deprecated."
        puts "Override to_create if you need to prevent a call to #save!."
      end
    end

    def assert_valid_strategy(strategy)
      unless Proxy.const_defined? variable_name_to_class_name(strategy)
        raise ArgumentError, "Unknown strategy: #{strategy}"
      end
    end

    # Based on ActiveSupport's underscore inflector
    def class_name_to_variable_name(name)
      name.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    # Based on ActiveSupport's camelize inflector
    def variable_name_to_class_name(name)
      name.to_s.
        gsub(/\/(.?)/) { "::#{$1.upcase}" }.
        gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    # From ActiveSupport
    def symbolize_keys(hash)
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end

    def trait_for(name)
      traits.detect {|trait| trait.name == name }
    end
  end
end
