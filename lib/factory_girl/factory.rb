class Factory

  # The list of Factory instances created using define
  cattr_accessor :factories
  self.factories = {}

  attr_reader :name

  # Defines a new factory that can be used by the generation methods (create,
  # build, and stub) to build new objects.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name used to identify this factory.
  #   options: (Hash)
  #     class: the class that will be used when generating instances for this
  #            factory.
  #
  # Yields:
  #    The newly created factory (Factory)
  def self.define (name, options = {})
    instance = Factory.new(name, options)
    yield(instance)
    self.factories[name] = instance
  end

  # Calculates the class that should be instantiated by generation methods.
  #
  # If a class was passed when defining this factory, that class will be
  # returned. Otherwise, the class will be guessed from the factory name.
  #
  # Returns:
  #   The class that will be instantiated by generation methods.
  def build_class
    @build_class ||= @options[:class] || name.to_s.classify.constantize
  end

  def initialize (name, options = {}) #:nodoc:
    options.assert_valid_keys(:class)
    @name    = name
    @options = options

    @static_attributes = {}
    @lazy_attributes   = {}
  end

  # Adds an attribute that should be assigned or stubbed on generated instances for this factory.
  #
  # This method should be called with either a value or block, but not both. If
  # called with a block, the attribute will be generated "lazily," whenever an
  # instance is generated. Lazy attribute blocks will not be called if that
  # attribute is overriden for a specific instance.
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of this attribute. This will be assigned using :"#{name}=" for
  #     generated instances, and stubbed out with this name for generated
  #     stubs.
  #   value: (Object)
  #     If no block is given, this value will be used for this attribute.
  def add_attribute (name, value = nil, &block)
    if block_given?
      unless value.nil?
        raise ArgumentError, "Both value and block given"
      end
      @lazy_attributes[name] = block
    else
      @static_attributes[name] = value
    end
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
  #     f.add_attribute :user, 'Billy Idol'
  #   end
  #
  # are equivilent. 
  def method_missing (name, *args, &block)
    add_attribute(name, *args, &block)
  end

  # Generates and returns a Hash of attributes from this factory. Attributes
  # can be individually overridden by passing in a Hash of attribute => value
  # pairs.
  #
  # Arguments:
  #   attrs: (Hash)
  #     Attributes to overwrite for this set.
  #
  # Returns:
  #   A set of attributes that can be used to build an instance of the class
  #   this factory generates. (Hash)
  def attributes_for (attrs = {})
    result = {}
    @lazy_attributes.each do |name, block|
      result[name] = block.call unless attrs.key?(name)
    end
    result.update(@static_attributes)
    result.update(attrs)
  end

  # Generates and returns an instance from this factory. Attributes can be
  # individually overridden by passing in a Hash of attribute => value pairs.
  #
  # Arguments:
  #   attrs: (Hash)
  #     See attributes_for
  #
  # Returns:
  #   An instance of the class this factory generates, with generated
  #   attributes assigned.
  def build (attrs = {})
    instance = build_class.new
    attributes_for(attrs).each do |attr, value|
      instance.send(:"#{attr}=", value)
    end
    instance
  end

  # Generates, saves, and returns an instance from this factory. Attributes can
  # be individually overridden by passing in a Hash of attribute => value
  # pairs.
  #
  # If the instance is not valid, an ActiveRecord::Invalid exception will be
  # raised.
  #
  # Arguments:
  #   attrs: (Hash)
  #     See attributes_for
  #
  # Returns:
  #   A saved instance of the class this factory generates, with generated
  #   attributes assigned.
  def create (attrs = {})
    instance = build(attrs)
    instance.save!
    instance
  end

  class << self

    def attributes_for (name, attrs = {})
      factory_by_name(name).attributes_for(attrs)
    end

    def build (name, attrs = {})
      factory_by_name(name).build(attrs)
    end

    def create (name, attrs = {})
      factory_by_name(name).create(attrs)
    end

    private

    def factory_by_name (name)
      factories[name] or raise ArgumentError.new("No such factory: #{name.inspect}")
    end

  end

end
