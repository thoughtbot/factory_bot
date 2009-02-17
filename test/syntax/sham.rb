require 'test_helper'

require 'factory_girl/syntax/sham'

class ShamSyntaxTest < Test::Unit::TestCase

  context "a factory" do
    setup do
      Sham.name  { "Name" }
      Sham.email { "somebody#{rand(5)}@example.com" }

      Factory.define :user do |factory|
        factory.first_name { Sham.name }
        factory.last_name  { Sham.name }
        factory.email      { Sham.email }
      end
    end

    teardown do
      Factory.factories.clear
      Factory.sequences.clear
    end

    context "after making an instance" do
      setup do
        @instance = Factory(:user, :last_name => 'Rye')
      end

      should "support a sham called 'name'" do
        assert_equal 'Name', @instance.first_name
      end

      should "use the sham for the email" do
        assert_match /somebody\d@example.com/, @instance.email
      end
    end
  end

end

