class MockFactory
  attr_reader :declarations, :traits, :callbacks

  def initialize
    @declarations = []
    @traits       = []
    @callbacks    = []
    @to_create    = nil
  end

  def to_create(&block)
    if block_given?
      @to_create = block
    else
      @to_create
    end
  end

  def declare_attribute(declaration)
    @declarations << declaration
  end

  def add_callback(callback)
    @callbacks << callback
  end

  def define_trait(trait)
    @traits << trait
  end
end
