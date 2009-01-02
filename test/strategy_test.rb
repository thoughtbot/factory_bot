require(File.join(File.dirname(__FILE__), 'test_helper'))

class StrategyTest < Test::Unit::TestCase

  context "a strategy" do
    setup do
      @strategy = Factory::Strategy.new(Class.new)
    end

    should "do nothing when asked to set an attribute to a value" do
      assert_nothing_raised { @strategy.set(:name, 'a name') }
    end

    should "return nil when asked for an attribute" do
      assert_nil @strategy.get(:name)
    end

    should "call get for a missing method" do
      @strategy.expects(:get).with(:name).returns("it's a name")
      assert_equal "it's a name", @strategy.name
    end

    should "do nothing when asked to associate with another factory" do
      assert_nothing_raised { @strategy.associate(:owner, :user, {}) }
    end

    should "raise an error when asked for the result" do
      assert_raise(NotImplementedError) { @strategy.result }
    end
  end

end

