class MockFactory
  attr_reader :declarations, :traits

  def initialize
    @declarations = []
    @traits       = []
    @callbacks    = Hash.new([])
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

  def build_callbacks
    @callbacks[:after_build]
  end

  def create_callbacks
    @callbacks[:after_create]
  end

  def stub_callbacks
    @callbacks[:after_stub]
  end

  def add_callback(callback_type, &callback)
    @callbacks[callback_type] << callback
  end

  def define_trait(trait)
    @traits << trait
  end
end
