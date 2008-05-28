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

  end

end
