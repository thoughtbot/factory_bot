require(File.join(File.dirname(__FILE__), 'test_helper'))

class AttributeTest < Test::Unit::TestCase

  context "an attribute" do

    setup do
      @name  = :user
      @proxy = mock('attribute-proxy')
      @attr  = Factory::Attribute.new(@name)
    end

    should "have a name" do
      assert_equal @name, @attr.name
    end

    context "after setting a static value" do

      setup do
        @value             = 'test'
        @attr.static_value = @value
      end

      should "return the value" do
        assert_equal @value, @attr.value(@proxy)
      end

    end

    context "after setting a lazy value" do

      setup do
        @attr.lazy_block = lambda { 'value' }
      end

      should "call the block to return a value" do
        assert_equal 'value', @attr.value(@proxy)
      end

      should "yield the attribute proxy to the block" do
        @attr.lazy_block = lambda {|a| a }
        assert_equal @proxy, @attr.value(@proxy)
      end

    end

  end

end
