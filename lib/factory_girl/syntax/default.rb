class Factory
  # Defines a new factory that can be used by the build strategies (create and
  # build) to build new objects.
  #
  # Arguments:
  # * name: +Symbol+ or +String+
  #   A unique name used to identify this factory.
  # * options: +Hash+
  #
  # Options:
  # * class: +Symbol+, +Class+, or +String+
  #   The class that will be used when generating instances for this factory. If not specified, the class will be guessed from the factory name.
  # * parent: +Symbol+
  #   The parent factory. If specified, the attributes from the parent
  #   factory will be copied to the current one with an ability to override
  #   them.
  # * default_strategy: +Symbol+
  #   The strategy that will be used by the Factory shortcut method.
  #   Defaults to :create.
  #
  # Yields: +Factory+
  # The newly created factory.
  def self.define(name, options = {})
    factory = Factory.new(name, options)
    proxy = Factory::DefinitionProxy.new(factory)
    yield(proxy)
    if parent = options.delete(:parent)
      factory.inherit_from(Factory.factory_by_name(parent))
    end
    register_factory(factory)
  end

  # Generates and returns a Hash of attributes from this factory. Attributes
  # can be individually overridden by passing in a Hash of attribute => value
  # pairs.
  #
  # Arguments:
  # * name: +Symbol+ or +String+
  #   The name of the factory that should be used.
  # * overrides: +Hash+
  #   Attributes to overwrite for this set.
  #
  # Returns: +Hash+
  # A set of attributes that can be used to build an instance of the class
  # this factory generates.
  def self.attributes_for (name, overrides = {})
    factory_by_name(name).run(Proxy::AttributesFor, overrides)
  end

  # Generates and returns an instance from this factory. Attributes can be
  # individually overridden by passing in a Hash of attribute => value pairs.
  #
  # Arguments:
  # * name: +Symbol+ or +String+
  #   The name of the factory that should be used.
  # * overrides: +Hash+
  #   Attributes to overwrite for this instance.
  #
  # Returns: +Object+
  # An instance of the class this factory generates, with generated attributes
  # assigned.
  def self.build (name, overrides = {})
    factory_by_name(name).run(Proxy::Build, overrides)
  end

  # Generates, saves, and returns an instance from this factory. Attributes can
  # be individually overridden by passing in a Hash of attribute => value
  # pairs.
  #
  # Instances are saved using the +save!+ method, so ActiveRecord models will
  # raise ActiveRecord::RecordInvalid exceptions for invalid attribute sets.
  #
  # Arguments:
  # * name: +Symbol+ or +String+
  #   The name of the factory that should be used.
  # * overrides: +Hash+
  #   Attributes to overwrite for this instance.
  #
  # Returns: +Object+
  # A saved instance of the class this factory generates, with generated
  # attributes assigned.
  def self.create (name, overrides = {})
    factory_by_name(name).run(Proxy::Create, overrides)
  end

  # Generates and returns an object with all attributes from this factory
  # stubbed out. Attributes can be individually overridden by passing in a Hash
  # of attribute => value pairs.
  #
  # Arguments:
  # * name: +Symbol+ or +String+
  #   The name of the factory that should be used.
  # * overrides: +Hash+
  #   Attributes to overwrite for this instance.
  #
  # Returns: +Object+
  # An object with generated attributes stubbed out.
  def self.stub (name, overrides = {})
    factory_by_name(name).run(Proxy::Stub, overrides)
  end

  # Executes the default strategy for the given factory. This is usually create,
  # but it can be overridden for each factory.
  #
  # Arguments:
  # * name: +Symbol+ or +String+
  #   The name of the factory that should be used.
  # * overrides: +Hash+
  #   Attributes to overwrite for this instance.
  #
  # Returns: +Object+
  # The result of the default strategy.
  def self.default_strategy (name, overrides = {})
    self.send(factory_by_name(name).default_strategy, name, overrides)
  end
end

# Shortcut for Factory.default_strategy.
#
# Example:
#   Factory(:user, :name => 'Joe')
def Factory (name, attrs = {})
  Factory.default_strategy(name, attrs)
end

