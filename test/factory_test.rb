require(File.join(File.dirname(__FILE__), 'test_helper'))

class FactoryTest < Test::Unit::TestCase

  context "defining a factory" do

    setup do
      @name    = :user
      @factory = mock('factory')
      Factory.stubs(:new).returns(@factory)
    end

    should "create a new factory" do
      Factory.expects(:new).with(@name)
      Factory.define(@name) {|f| }
    end

    should "pass the factory do the block" do
      yielded = nil
      Factory.define(@name) do |y|
        yielded = y
      end
      assert_equal @factory, yielded
    end

    should "add the factory to the list of factories" do
      Factory.define(@name) {|f| }
      assert Factory.factories.include?(@factory),
             "Factories: #{Factory.factories.inspect}"
    end

  end

  context "a factory" do

    setup do
      @name    = :user
      @factory = Factory.new(@name)
    end

    should "have a name" do
      assert_equal @name, @factory.name
    end

    context "when adding an attribute with a value parameter" do

      setup do
        @attr  = :name
        @value = 'Elvis lives!'
        @factory.add_attribute(@attr, @value)
      end

      should "include that value in the generated attributes hash" do
        assert_equal @value, @factory.attributes[@attr]
      end

    end

    context "when adding an attribute with a block" do

      setup do
        @attr = :name
      end

      should "not evaluate the block when the attribute is added" do
        @factory.add_attribute(@attr) { flunk }
      end

      should "evaluate the block when attributes are generated" do
        called = false
        @factory.add_attribute(@attr) do
          called = true
        end
        @factory.attributes
        assert called
      end

      should "use the result of the block as the value of the attribute" do
        value = "Watch out for snakes!"
        @factory.add_attribute(@attr) { value }
        assert_equal value, @factory.attributes[@attr]
      end

    end

    should "not allow attributes to be added with both a value parameter and a block" do
      assert_raise(ArgumentError) do
        @factory.add_attribute(:name, 'value') {}
      end
    end

    context "when overriding generated attributes with a hash" do

      setup do
        @attr  = :name
        @value = 'The price is right!'
        @hash  = { @attr => @value }
      end

      should "return the overridden value in the generated attributes" do
        @factory.add_attribute(@attr, 'The price is wrong, Bob!')
        assert_equal @value, @factory.attributes(@hash)[@attr]
      end

      should "not call a lazy attribute block for an overridden attribute" do
        @factory.add_attribute(@attr) { flunk }
        @factory.attributes(@hash)
      end

    end

  end

end
