require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributeProxyTest < Test::Unit::TestCase

  context "an association proxy" do

    setup do
      @factory  = mock('factory')
      @attr     = :user
      @attrs    = { :first_name => 'John' }
      @strategy = :create
      @proxy  = Factory::AttributeProxy.new(@factory, @attr, @strategy, @attrs)
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

    should "have attributes" do
      assert_equal @attrs, @proxy.current_values
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

    context "building an association using the attributes_for strategy" do

      setup do
        @strategy = :attributes_for
        @proxy  = Factory::AttributeProxy.new(@factory, @attr, @strategy, @attrs)
      end

      should "not build the association" do
        Factory.expects(@strategy).never
        @proxy.association(:user)
      end

      should "return nil for the association" do
        Factory.stubs(@strategy).returns(:user)
        assert_nil @proxy.association(:user)
      end

    end

    context "building an association using the build strategy" do

      setup do
        @strategy = :build
        @built    = 'object'
        @proxy    = Factory::AttributeProxy.new(@factory, @attr, @strategy, @attrs)
        Factory.stubs(:create).returns(@built)
      end

      should "create the association" do
        Factory.expects(:create).with(:user, {}).returns(@built)
        @proxy.association(:user)
      end

      should "return the created object" do
        assert_equal @built, @proxy.association(:user)
      end

    end

    context "fetching the value of an attribute" do

      setup do
        @attr = :first_name
      end

      should "return the correct value" do
        assert_equal @attrs[@attr], @proxy.value_for(@attr)
      end

      should "call value_for for undefined methods" do
        assert_equal @attrs[@attr], @proxy.send(@attr)
      end

    end

    context "fetching the value of an undefined attribute" do

      setup do
        @attr = :beachball
      end

      should "raise an ArgumentError" do
        assert_raise(ArgumentError) { @proxy.value_for(@attr) }
      end

    end

  end

end
