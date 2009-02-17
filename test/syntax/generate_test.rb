require 'test_helper'

require 'factory_girl/syntax/generate'

class GenerateSyntaxTest < Test::Unit::TestCase

  context "a factory" do
    setup do
      Factory.define :user do |factory|
        factory.first_name 'Bill'
        factory.last_name  'Nye'
        factory.email      'science@guys.net'
      end
    end

    teardown do
      Factory.factories.clear
    end

    should "not raise an error when generating an invalid instance" do
      assert_nothing_raised { User.generate(:first_name => nil) }
    end

    should "raise an error when forcefully generating an invalid instance" do
      assert_raise ActiveRecord::RecordInvalid do
        User.generate!(:first_name => nil)
      end
    end

    %w(generate generate! spawn).each do |method|
      should "yield a generated instance when using #{method} with a block" do
        instance = nil
        User.send(method) {|instance| }
        assert_kind_of User, instance
      end

      context "after generating an instance using #{method}" do
        setup do
          @instance = User.send(method, :last_name => 'Rye')
        end

        should "use attributes from the factory" do
          assert_equal 'Bill', @instance.first_name
        end

        should "use attributes passed to generate" do
          assert_equal 'Rye', @instance.last_name
        end

        if method == 'spawn'
          should "not save the record" do
            assert @instance.new_record?
          end
        else
          should "save the record" do
            assert !@instance.new_record?
          end
        end
      end
    end
  end

end
