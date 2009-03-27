require 'test_helper'

class StubProxyTest < Test::Unit::TestCase
  context "the stub proxy" do
    setup do
      @proxy = Factory::Proxy::Stub.new(@class)
    end
    
    context "when asked to associate with another factory" do
      setup do
        Factory.stubs(:create)
        @proxy.associate(:owner, :user, {})
      end

      should "not set a value for the association" do
        assert_nil @proxy.result.owner
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

    should "return a mock object when asked for the result" do
      assert_kind_of Object, @proxy.result
    end

    context "setting an attribute" do
      should "define attributes even if attribute= is defined" do
        @proxy.set('attribute', nil)
        assert_nothing_raised do
          @proxy.set('age', 18)
        end
      end
    end

    context "after setting an attribute" do
      setup do
        @proxy.set(:attribute, 'value')
      end

      should "add a stub to the resulting object" do
        assert_equal 'value', @proxy.attribute
      end

      should "return that value when asked for that attribute" do
        assert_equal 'value', @proxy.get(:attribute)
      end
    end    
  end
end
