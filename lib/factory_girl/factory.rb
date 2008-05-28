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
  end

end
