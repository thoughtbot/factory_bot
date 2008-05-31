require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributeProxyTest < Test::Unit::TestCase

  context "an association proxy" do

    setup do
      @factory  = mock('factory')
      @attr     = :user
      @strategy = :create
      @proxy  = Factory::AttributeProxy.new(@factory, @attr, @strategy)
    end

    should "have a factory" do
      assert_equal @factory, @proxy.factory
    end

    should "have an attribute name" do
      assert_equal @attr, @proxy.attribute_name
    end

    should "have a build strategy" do
      assert_equal @strategy, @proxy.strategy
    end

    context "building an association" do

      setup do
        @association = mock('built-user')
        @name        = :user
        @attribs     = { :first_name => 'Billy' }

        Factory.stubs(@strategy).returns(@association)
      end

      should "delegate to the appropriate method on Factory" do
        Factory.expects(@strategy).with(@name, @attribs).returns(@association)
        @proxy.association(@name, @attribs)
      end

      should "return the built association" do
        assert_equal @association, @proxy.association(@name)
      end

    end

  end

end
