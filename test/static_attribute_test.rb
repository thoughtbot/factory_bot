require 'test_helper'

class StaticAttributeTest < Test::Unit::TestCase

  context "a static attribute" do
    setup do
      @name  = :first_name
      @value = 'John'
      @attr  = Factory::Attribute::Static.new(@name, @value)
    end

    should "have a name" do
      assert_equal @name, @attr.name
    end

    should "set its static value on a proxy" do
      @proxy = mock('proxy')
      @proxy.expects(:set).with(@name, @value)
      @attr.add_to(@proxy)
    end
  end

  should "raise an error when defining an attribute writer" do
    assert_raise Factory::AttributeDefinitionError do
      Factory::Attribute::Static.new('test=', nil)
    end
  end

  should "convert names to symbols" do
    assert_equal :name, Factory::Attribute::Static.new('name', nil).name
  end

end
