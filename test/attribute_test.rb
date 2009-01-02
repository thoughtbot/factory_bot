require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributeTest < Test::Unit::TestCase

  def setup
    @strategy = mock('strategy')
  end

  context "an attribute" do
    setup do
      @name  = :user
      @attr  = Factory::Attribute.new(@name, 'test', nil)
    end

    should "have a name" do
      assert_equal @name, @attr.name
    end
  end

  context "an attribute with a static value" do
    setup do
      @value = 'test'
      @attr  = Factory::Attribute.new(:user, @value, nil)
    end

    should "return the static value when asked for its value" do
      assert_equal @value, @attr.value(@strategy)
    end
  end

  context "an attribute with a lazy value" do
    setup do
      @block = lambda { 'value' }
      @attr  = Factory::Attribute.new(:user, nil, @block)
    end

    should "call the block to return a value" do
      assert_equal 'value', @attr.value(@strategy)
    end

    should "yield the passed strategy to the block" do
      @block = lambda {|a| a }
      @attr  = Factory::Attribute.new(:user, nil, @block)
      assert_equal @strategy, @attr.value(@strategy)
    end
  end

  should "raise an error when defining an attribute writer" do
    assert_raise Factory::AttributeDefinitionError do
      Factory::Attribute.new('test=', nil, nil)
    end
  end

  should "not accept both a value parameter and a block" do
    assert_raise(Factory::AttributeDefinitionError) do
      Factory::Attribute.new(:name, 'value', lambda {})
    end
  end

  should "convert names to symbols" do
    assert_equal :name, Factory::Attribute.new('name', nil, nil).name
  end

end
