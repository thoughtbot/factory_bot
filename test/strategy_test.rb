require 'test_helper'

class Proxy < Test::Unit::TestCase

  context "a proxy" do
    setup do
      @proxy = Factory::Proxy.new(Class.new)
    end

    should "do nothing when asked to set an attribute to a value" do
      assert_nothing_raised { @proxy.set(:name, 'a name') }
    end

    should "return nil when asked for an attribute" do
      assert_nil @proxy.get(:name)
    end

    should "call get for a missing method" do
      @proxy.expects(:get).with(:name).returns("it's a name")
      assert_equal "it's a name", @proxy.name
    end

    should "do nothing when asked to associate with another factory" do
      assert_nothing_raised { @proxy.associate(:owner, :user, {}) }
    end

    should "raise an error when asked for the result" do
      assert_raise(NotImplementedError) { @proxy.result }
    end
  end

end

