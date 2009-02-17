require 'test_helper'

class DynamicAttributeTest < Test::Unit::TestCase

  context "a static attribute" do
    setup do
      @name  = :first_name
      @block = lambda { 'value' }
      @attr  = Factory::Attribute::Dynamic.new(@name, @block)
    end

    should "have a name" do
      assert_equal @name, @attr.name
    end

    should "call the block to set a value" do
      @proxy = mock('proxy')
      @proxy.expects(:set).with(@name, 'value')
      @attr.add_to(@proxy)
    end

    should "yield the proxy to the block when adding its value to a proxy" do
      @block = lambda {|a| a }
      @attr  = Factory::Attribute::Dynamic.new(:user, @block)
      @proxy = mock('proxy')
      @proxy.expects(:set).with(:user, @proxy)
      @attr.add_to(@proxy)
    end
  end

  should "raise an error when defining an attribute writer" do
    assert_raise Factory::AttributeDefinitionError do
      Factory::Attribute::Dynamic.new('test=', nil)
    end
  end

  should "convert names to symbols" do
    assert_equal :name, Factory::Attribute::Dynamic.new('name', nil).name
  end

end
