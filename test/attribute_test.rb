require 'test_helper'

class AttributeTest < Test::Unit::TestCase

  context "an attribute" do
    setup do
      @name  = :user
      @attr  = Factory::Attribute.new(@name)
    end

    should "have a name" do
      assert_equal @name, @attr.name
    end

    should "do nothing when being added to a proxy" do
      @proxy = mock('proxy')
      @proxy.expects(:set).never
      @attr.add_to(@proxy)
    end
  end

  should "raise an error when defining an attribute writer" do
    assert_raise Factory::AttributeDefinitionError do
      Factory::Attribute.new('test=')
    end
  end

  should "convert names to symbols" do
    assert_equal :name, Factory::Attribute.new('name').name
  end

end
