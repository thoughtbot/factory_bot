class Factory
  
  class << self
    attr_accessor :factories #:nodoc:

    # An Array of strings specifying locations that should be searched for
    # factory definitions. By default, factory_girl will attempt to require
    # "factories," "test/factories," and "spec/factories." Only the first
    # existing file will be loaded.
    attr_accessor :definition_file_paths
  end

  self.factories = {}
  self.definition_file_paths = %w(factories test/factories spec/factories)

  attr_reader :factory_name
  attr_reader :attributes #:nodoc:

  # Defines a new factory that can be used by the build strategies (create and
  # build) to build new objects.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name used to identify this factory.
  #   options: (Hash)
  #     class: the class that will be used when generating instances for this
  #            factory. If not specified, the class will be guessed from the 
  #            factory name.
  #
  # Yields:
  #    The newly created factory (Factory)
  def self.define (name, options = {})
    instance = Factory.new(name, options)
    yield(instance)
    self.factories[instance.factory_name] = instance
  end

  def build_class #:nodoc:
    @build_class ||= class_for(@options[:class] || factory_name)
  end

  def initialize (name, options = {}) #:nodoc:
    assert_valid_options(options)
    @factory_name = factory_name_for(name)
    @options      = options
    @attributes   = []
  end

  # Adds an attribute that should be assigned on generated instances for this
  # factory.
  #
  # This method should be called with either a value or block, but not both. If
  # called with a block, the attribute will be generated "lazily," whenever an
  # instance is generated. Lazy attribute blocks will not be called if that
  # attribute is overriden for a specific instance.
  #
  # When defining lazy attributes, an instance of Factory::Proxy will
  # be yielded, allowing associations to be built using the correct build
  # strategy.
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of this attribute. This will be assigned using :"#{name}=" for
  #     generated instances.
  #   value: (Object)
  #     If no block is given, this value will be used for this attribute.
  def add_attribute (name, value = nil, &block)
    if block_given?
      if value
        raise AttributeDefinitionError, "Both value and block given"
      else
        attribute = Attribute::Dynamic.new(name, block)
      end
    else
      attribute = Attribute::Static.new(name, value)
    end

    if attribute_defined?(attribute.name)
      raise AttributeDefinitionError, "Attribute already defined: #{name}"
    end

    @attributes << attribute
  end

  # Calls add_attribute using the missing method name as the name of the
  # attribute, so that:
  #
  #   Factory.define :user do |f|
  #     f.name 'Billy Idol'
  #   end
  #
  # and:
  #
  #   Factory.define :user do |f|
  #     f.add_attribute :name, 'Billy Idol'
  #   end
  #
  # are equivilent. 
  def method_missing (name, *args, &block)
    add_attribute(name, *args, &block)
  end

  # Adds an attribute that builds an association. The associated instance will
  # be built using the same build strategy as the parent instance.
  #
  # Example:
  #   Factory.define :user do |f|
  #     f.name 'Joey'
  #   end
  #
  #   Factory.define :post do |f|
  #     f.association :author, :factory => :user
  #   end
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of this attribute.
  #   options: (Hash)
  #     factory: (Symbol)
  #       The name of the factory to use when building the associated instance.
  #       If no name is given, the name of the attribute is assumed to be the
  #       name of the factory. For example, a "user" association will by
  #       default use the "user" factory.
  def association (name, options = {})
    factory_name = options.delete(:factory) || name
    @attributes << Attribute::Association.new(name, factory_name, options)
  end

  # Generates and returns a Hash of attributes from this factory. Attributes
  # can be individually overridden by passing in a Hash of attribute => value
  # pairs.
  #
  # Arguments:
  #   overrides: (Hash)
  #     Attributes to overwrite for this set.
  #
  # Returns:
  #   A set of attributes that can be used to build an instance of the class
  #   this factory generates. (Hash)
  def self.attributes_for (name, overrides = {})
    factory_by_name(name).run(Proxy::AttributesFor, overrides)
  end

  # Generates and returns an instance from this factory. Attributes can be
  # individually overridden by passing in a Hash of attribute => value pairs.
  #
  # Arguments:
  #   overrides: (Hash)
  #     See attributes_for
  #
  # Returns:
  #   An instance of the class this factory generates, with generated
  #   attributes assigned.
  def self.build (name, overrides = {})
    factory_by_name(name).run(Proxy::Build, overrides)
  end

  # Generates, saves, and returns an instance from this factory. Attributes can
  # be individually overridden by passing in a Hash of attribute => value
  # pairs.
  #
  # If the instance is not valid, an ActiveRecord::Invalid exception will be
  # raised.
  #
  # Arguments:
  #   overrides: (Hash)
  #     See attributes_for
  #
  # Returns:
  #   A saved instance of the class this factory generates, with generated
  #   attributes assigned.
  def self.create (name, overrides = {})
    factory_by_name(name).run(Proxy::Create, overrides)
  end

  def self.find_definitions #:nodoc:
    definition_file_paths.each do |path|
      require("#{path}.rb") if File.exists?("#{path}.rb")

      if File.directory? path
        Dir[File.join(path, '*.rb')].each do |file|
          require file
        end
      end
    end
  end

  def run (proxy_class, overrides) #:nodoc:
    proxy = proxy_class.new(build_class)
    overrides = symbolize_keys(overrides)
    overrides.each {|attr, val| proxy.set(attr, val) }
    passed_keys = overrides.keys.collect {|k| Factory.aliases_for(k) }.flatten
    @attributes.each do |attribute|
      unless passed_keys.include?(attribute.name)
        attribute.add_to(proxy)
      end
    end
    proxy.result
  end

  private

  def self.factory_by_name (name)
    factories[name.to_sym] or raise ArgumentError.new("No such factory: #{name.to_s}")
  end

  def class_for (class_or_to_s)
    if class_or_to_s.respond_to?(:to_sym)
      Object.const_get(variable_name_to_class_name(class_or_to_s))
    else
      class_or_to_s
    end
  end

  def factory_name_for (class_or_to_s)
    if class_or_to_s.respond_to?(:to_sym)
      class_or_to_s.to_sym
    else
      class_name_to_variable_name(class_or_to_s).to_sym
    end
  end

  def attribute_defined? (name)
    !@attributes.detect {|attr| attr.name == name }.nil?
  end

  def assert_valid_options(options)
    invalid_keys = options.keys - [:class] 
    unless invalid_keys == []
      raise ArgumentError, "Unknown arguments: #{invalid_keys.inspect}"
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

end
