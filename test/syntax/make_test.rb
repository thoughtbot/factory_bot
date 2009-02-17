require 'test_helper'

require 'factory_girl/syntax/make'

class MakeSyntaxTest < Test::Unit::TestCase

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

    context "after making an instance" do
      setup do
        @instance = User.make(:last_name => 'Rye')
      end

      should "use attributes from the factory" do
        assert_equal 'Bill', @instance.first_name
      end

      should "use attributes passed to make" do
        assert_equal 'Rye', @instance.last_name
      end

      should "save the record" do
        assert !@instance.new_record?
      end
    end
  end

end
