require 'test_helper'

class CreateProxyTest < Test::Unit::TestCase

  context "with a class to build" do
    setup do
      @class       = Class.new
      @instance    = mock('built-instance')
      @association = mock('associated-instance')

      @class.   stubs(:new).      returns(@instance)
      Factory.  stubs(:create).   returns(@association)
      @instance.stubs(:attribute).returns('value')
      @instance.stubs(:attribute=)
      @instance.stubs(:owner=)
      @instance.stubs(:save!)
    end

    context "the create proxy" do
      setup do
        @proxy = Factory::Proxy::Create.new(@class)
      end

      before_should "instantiate the class" do
        @class.expects(:new).with().returns(@instance)
      end

      context "when asked to associate with another factory" do
        setup do
          @proxy.associate(:owner, :user, {})
        end

        before_should "create the associated instance" do
          Factory.expects(:create).with(:user, {}).returns(@association)
        end

        before_should "set the associated instance" do
          @instance.expects(:owner=).with(@association)
        end
      end

      should "call Factory.create when building an association" do
        association = 'association'
        attribs     = { :first_name => 'Billy' }
        Factory.expects(:create).with(:user, attribs).returns(association)
        assert_equal association, @proxy.association(:user, attribs)
      end

      context "when asked for the result" do
        setup do
          @result = @proxy.result
        end

        before_should "save the instance" do
          @instance.expects(:save!).with()
        end

        should "return the built instance" do
          assert_equal @instance, @result
        end
      end

      context "when setting an attribute" do
        setup do
          @proxy.set(:attribute, 'value')
        end

        before_should "set that value" do
          @instance.expects(:attribute=).with('value')
        end
      end

      context "when getting an attribute" do
        setup do
          @result = @proxy.get(:attribute)
        end

        before_should "ask the built class for the value" do
          @instance.expects(:attribute).with().returns('value')
        end

        should "return the value for that attribute" do
          assert_equal 'value', @result
        end
      end
    end
  end

end

