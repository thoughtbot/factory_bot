require 'test_helper'

class AssociationAttributeTest < Test::Unit::TestCase

  context "an association" do
    setup do
      @name      = :author
      @factory   = :user
      @overrides = { :first_name => 'John' }
      @attr      = Factory::Attribute::Association.new(@name,
                                                       @factory,
                                                       @overrides)
    end

    should "have a name" do
      assert_equal @name, @attr.name
    end

    should "tell the proxy to associate when being added to a proxy" do
      proxy = mock('proxy')
      proxy.expects(:associate).with(@name, @factory, @overrides)
      @attr.add_to(proxy)
    end
  end

  should "convert names to symbols" do
    assert_equal :name, 
                 Factory::Attribute::Association.new('name', :user, {}).name
  end

end
