class Factory
  
  class AttributeDefinitionError < RuntimeError
  end
  
  cattr_accessor :factories, :sequences #:nodoc:
  self.factories = {}
  self.sequences = {}

  attr_reader :factory_name

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

  # Defines a new sequence that can be used to generate unique values in a specific format.
  #
  # Arguments:
  #   name: (Symbol)
  #     A unique name for this sequence. This name will be referenced when
  #     calling next to generate new values from this sequence.
  #   block: (Proc)
  #     The code to generate each value in the sequence. This block will be
  #     called with a unique number each time a value in the sequence is to be
  #     generated. The block should return the generated value for the
  #     sequence.
  #
  # Example:
  #   
  #   Factory.sequence(:email) {|n| "somebody_#{n}@example.com" }
  def self.sequence (name, &block)
    self.sequences[name] = Sequence.new(&block)
  end

  # Generates and returns the next value in a sequence.
  #
  # Arguments:
  #   name: (Symbol)
  #     The name of the sequence that a value should be generated for.
  #
  # Returns:
  #   The next value in the sequence. (Object)
  def self.next (sequence)
    unless self.sequences.key?(sequence)
      raise "No such sequence: #{sequence}"
    end

    self.sequences[sequence].next
  end

  def build_class #:nodoc:
    @build_class ||= class_for(@options[:class] || factory_name)
  end

  def initialize (name, options = {}) #:nodoc:
    options.assert_valid_keys(:class)
    @factory_name = factory_name_for(name)
    @options      = options

    @static_attributes     = {}
    @lazy_attribute_blocks = {}
    @lazy_attribute_names  = []
  end

  # Adds an attribute that should be assigned on generated instances for this
  # factory.
  #
  # This method should be called with either a value or block, but not both. If
  # called with a block, the attribute will be generated "lazily," whenever an
  # instance is generated. Lazy attribute blocks will not be called if that
  # attribute is overriden for a specific instance.
  #
  # When defining lazy attributes, an instance of Factory::AttributeProxy will
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
    name = name.to_sym

    if name.to_s =~ /=$/
      raise AttributeDefinitionError, 
        "factory_girl uses 'f.#{name.to_s.chop} #{value}' syntax " +
        "rather than 'f.#{name} #{value}'" 
    end
    
    if block_given?
      unless value.nil?
        raise ArgumentError, "Both value and block given"
      end
      @lazy_attribute_blocks[name] = block
      @lazy_attribute_names << name
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
    name    = name.to_sym
    options = options.symbolize_keys
    association_factory = options[:factory] || name

    add_attribute(name) {|a| a.association(association_factory) }
  end

  def attributes_for (attrs = {}) #:nodoc:
    build_attributes_hash(attrs, :attributes_for)
  end

  def build (attrs = {}) #:nodoc:
    build_instance(attrs, :build)
  end

  def create (attrs = {}) #:nodoc:
    instance = build_instance(attrs, :create)
    instance.save!
    instance
  end

  class << self

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
    def attributes_for (name, attrs = {})
      factory_by_name(name).attributes_for(attrs)
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
    def build (name, attrs = {})
      factory_by_name(name).build(attrs)
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
    def create (name, attrs = {})
      factory_by_name(name).create(attrs)
    end

    private

    def factory_by_name (name)
      factories[name.to_sym] or raise ArgumentError.new("No such factory: #{name.to_s}")
    end

  end

  private

  def build_attributes_hash (override, strategy)
    override = override.symbolize_keys
    result = @static_attributes.merge(override)
    @lazy_attribute_names.each do |name|
      proxy = AttributeProxy.new(self, name, strategy, result)
      result[name] = @lazy_attribute_blocks[name].call(proxy) unless override.key?(name)
    end
    result
  end

  def build_instance (override, strategy)
    instance = build_class.new
    attrs = build_attributes_hash(override, strategy)
    attrs.each do |attr, value|
      instance.send(:"#{attr}=", value)
    end
    instance
  end

  def class_for (class_or_to_s)
    if class_or_to_s.respond_to?(:to_sym)
      class_or_to_s.to_s.classify.constantize
    else
      class_or_to_s
    end
  end

  def factory_name_for (class_or_to_s)
    if class_or_to_s.respond_to?(:to_sym)
      class_or_to_s.to_sym
    else
      class_or_to_s.to_s.underscore.to_sym
    end
  end

end
