require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributeProxyTest < Test::Unit::TestCase

  context "an association proxy" do
    setup do
      @strategy = mock('strategy')
      @proxy  = Factory::AttributeProxy.new(@strategy)
    end

    should "have a strategy" do
      assert_equal @strategy, @proxy.strategy
    end

    should "return a value from the strategy for an attribute's value" do
      @strategy.expects(:get).with(:name).returns("it's a name")
      assert_equal "it's a name", @proxy.value_for(:name)
    end

    should "return a value from the strategy for an undefined method" do
      @strategy.expects(:get).with(:name).returns("it's a name")
      assert_equal "it's a name", @proxy.name
    end
  end

  context "an association proxy using the AttributesFor strategy" do
    setup do
      @strategy = Factory::Strategy::AttributesFor.new(Object)
      @proxy    = Factory::AttributeProxy.new(@strategy)
    end

    should "not call Factory.create when building an association" do
      Factory.expects(:create).never
      @proxy.association(:user)
    end

    should "return the nil when building an association" do
      assert_nil @proxy.association(:user)
    end
  end

  [Factory::Strategy::Build, Factory::Strategy::Create].each do |strategy_class|
    context "an association proxy using the #{strategy_class.name} strategy" do
      setup do
        @strategy = strategy_class.new(Object)
        @proxy  = Factory::AttributeProxy.new(@strategy)
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
