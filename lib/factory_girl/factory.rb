class Factory

  # The list of Factory instances created using define
  cattr_accessor :factories
  self.factories = []

  attr_reader :name

  # Defines a new factory that can be used by the generation methods (create,
  # build, and stub) to build new objects.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name used to identify this factory.
  #
  # Yields:
  #    The newly created factory (Factory)
  def self.define (name)
    instance = Factory.new(name)
    yield(instance)
    self.factories << instance
  end

  def initialize (name) #:nodoc:
    @name = name
    @static_attributes = {}
    @lazy_attributes = {}
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
  def attributes (attrs = {})
    result = {}
    @lazy_attributes.each do |name, block|
      result[name] = block.call unless attrs.key?(name)
    end
    result.update(@static_attributes)
    result.update(attrs)
  end

end
