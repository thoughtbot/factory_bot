require 'test_helper'

class AttributesForProxyTest < Test::Unit::TestCase

  context "the attributes_for proxy" do
    setup do
      @proxy = Factory::Proxy::AttributesFor.new(@class)
    end

    context "when asked to associate with another factory" do
      setup do
        Factory.stubs(:create)
        @proxy.associate(:owner, :user, {})
      end

      should "not set a value for the association" do
        assert !@proxy.result.key?(:owner)
      end
    end

    should "return nil when building an association" do
      assert_nil @proxy.association(:user)
    end

    should "not call Factory.create when building an association" do
      Factory.expects(:create).never
      assert_nil @proxy.association(:user)
    end

    should "always return nil when building an association" do
      @proxy.set(:association, 'x')
      assert_nil @proxy.association(:user)
    end

    should "return a hash when asked for the result" do
      assert_kind_of Hash, @proxy.result
    end

    context "after setting an attribute" do
      setup do
        @proxy.set(:attribute, 'value')
      end

      should "set that value in the resulting hash" do
        assert_equal 'value', @proxy.result[:attribute]
      end

      should "return that value when asked for that attribute" do
        assert_equal 'value', @proxy.get(:attribute)
      end
    end
  end

end

