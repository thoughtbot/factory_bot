require 'test_helper'

class BuildProxyTest < Test::Unit::TestCase

  context "with a class to build" do
    setup do
      @class       = Class.new
      @instance    = "built-instance"
      @association = "associated-instance"

      stub(@class).new { @instance }
      stub(@instance).attribute { 'value' }
      stub(Factory).create { @association }
      stub(@instance, :attribute=)
      stub(@instance, :owner=)
    end

    context "the build proxy" do
      setup do
        @proxy = Factory::Proxy::Build.new(@class)
      end

      should "instantiate the class" do
        assert_received(@class) {|p| p.new }
      end

      context "when asked to associate with another factory" do
        setup do
          @proxy.associate(:owner, :user, {})
        end

        should "create the associated instance" do
          assert_received(Factory) {|p| p.create(:user, {}) }
        end

        should "set the associated instance" do
          assert_received(@instance) {|p| p.method_missing(:owner=, @association) }
        end
      end

      should "call Factory.create when building an association" do
        association = 'association'
        attribs     = { :first_name => 'Billy' }
        stub(Factory).create { association }
        assert_equal association, @proxy.association(:user, attribs)
        assert_received(Factory) {|p| p.create(:user, attribs) }
      end

      should "return the built instance when asked for the result" do
        assert_equal @instance, @proxy.result
      end

      context "when setting an attribute" do
        setup do
          stub(@instance).attribute = 'value'
          @proxy.set(:attribute, 'value')
        end

        should "set that value" do
          assert_received(@instance) {|p| p.method_missing(:attribute=, 'value') }
        end
      end

      context "when getting an attribute" do
        setup do
          @result = @proxy.get(:attribute)
        end

        should "ask the built class for the value" do
          assert_received(@instance) {|p| p.attribute }
        end

        should "return the value for that attribute" do
          assert_equal 'value', @result
        end
      end
    end
  end

end

