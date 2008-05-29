require(File.join(File.dirname(__FILE__), 'test_helper'))

class FactoryTest < Test::Unit::TestCase

  def self.should_instantiate_class

    should "instantiate the build class" do
      assert_kind_of @class, @instance
    end

    should "assign attributes on the instance" do
      assert_equal @first_name, @instance.first_name
      assert_equal @last_name,  @instance.last_name
    end

    should "override attributes using the passed hash" do
      @value = 'Davis'
      @instance = @factory.build(:first_name => @value)
      assert_equal @value, @instance.first_name
    end

  end

  context "defining a factory" do

    setup do
      @name    = :user
      @factory = mock('factory')
      @options = { :class => 'magic' }
      Factory.stubs(:new).returns(@factory)
    end

    should "create a new factory using the specified name and options" do
      Factory.expects(:new).with(@name, @options)
      Factory.define(@name, @options) {|f| }
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
      @class   = User
      @factory = Factory.new(@name)
    end

    should "have a name" do
      assert_equal @name, @factory.name
    end

    should "have a build class" do
      assert_equal @class, @factory.build_class
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

    should "add an attribute using the method name when passed an undefined method" do
      @attr  = :first_name
      @value = 'Sugar'
      @factory.send(@attr, @value)
      assert_equal @value, @factory.attributes[@attr]
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

    should "guess the build class from the factory name" do
      assert_equal User, @factory.build_class
    end

    context "when defined with a custom class" do

      setup do
        @class   = User
        @factory = Factory.new(:author, :class => @class)
      end

      should "use the specified class as the build class" do
        assert_equal @class, @factory.build_class
      end

    end

    context "with some attributes added" do

      setup do
        @first_name = 'Billy'
        @last_name  = 'Idol'
        @email      = 'test@something.com'

        @factory.add_attribute(:first_name, @first_name)
        @factory.add_attribute(:last_name,  @last_name)
        @factory.add_attribute(:email,      @email)
      end

      context "when building an instance" do

        setup do
          @instance = @factory.build
        end

        should_instantiate_class

      end
      
      context "when creating an instance" do

        setup do
          User.delete_all
          @instance = @factory.create
        end

        should_instantiate_class

        should "save the instance" do
          assert_equal 1, @class.count
        end

      end

      should "raise an ActiveRecord::RecordInvalid error for invalid instances" do
        assert_raise(ActiveRecord::RecordInvalid) do
          @factory.create(:first_name => nil)
        end
      end

    end

  end

end
