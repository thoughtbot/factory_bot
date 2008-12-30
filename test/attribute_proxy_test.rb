require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributeProxyTest < Test::Unit::TestCase

  context "an association proxy" do
    setup do
      @attrs    = { :first_name => 'John' }
      @strategy = :create
      @proxy  = Factory::AttributeProxy.new(@strategy, @attrs)
    end

    should "have a build strategy" do
      assert_equal @strategy, @proxy.strategy
    end

    should "have attributes" do
      assert_equal @attrs, @proxy.current_values
    end

    should "return the correct value for an attribute" do
      assert_equal @attrs[:first_name], @proxy.value_for(:first_name)
    end

    should "call value_for for undefined methods" do
      assert_equal @attrs[:first_name], @proxy.send(:first_name)
    end
  end

  context "an association proxy using the AttributesFor strategy" do
    setup do
      @attrs    = { :first_name => 'John' }
      @strategy = :attributes_for
      @proxy  = Factory::AttributeProxy.new(@strategy, @attrs)
    end

    should "call Factory.create when building an association" do
      Factory.expects(:create).never
      @proxy.association(:user)
    end

    should "return the nil when building an association" do
      assert_nil @proxy.association(:user)
    end
  end

  %w(build create).each do |strategy|
    context "an association proxy using the #{strategy} strategy" do
      setup do
        @attrs    = { :first_name => 'John' }
        @strategy = :"#{strategy}"
        @proxy  = Factory::AttributeProxy.new(@strategy, @attrs)
      end

      should "call Factory.create when building an association" do
        attribs = { :first_name => 'Billy' }
        Factory.expects(:create).with(:user, attribs).returns(@association)
        @proxy.association(:user, attribs)
      end

      should "return the built association" do
        association = mock('built-user')
        Factory.stubs(:create).returns(association)
        assert_equal association, @proxy.association(:user)
      end
    end
  end

end
