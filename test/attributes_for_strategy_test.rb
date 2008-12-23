require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributesForStrategyTest < Test::Unit::TestCase

  context "the build strategy" do
    setup do
      @strategy = Factory::Strategy::AttributesFor.new(@class)
    end

    context "when asked to associate with another factory" do
      setup do
        Factory.stubs(:create)
        @strategy.associate(:owner, :user, {})
      end

      should "not set a value for the association" do
        assert !@strategy.result.key?(:owner)
      end
    end

    should "return a hash when asked for the result" do
      assert_kind_of Hash, @strategy.result
    end

    context "after setting an attribute" do
      setup do
        @strategy.set(:attribute, 'value')
      end

      should "set that value in the resulting hash" do
        assert_equal 'value', @strategy.result[:attribute]
      end

      should "return that value when asked for that attribute" do
        assert_equal 'value', @strategy.get(:attribute)
      end
    end
  end

end

