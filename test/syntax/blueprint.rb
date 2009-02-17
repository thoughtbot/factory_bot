require 'test_helper'

require 'factory_girl/syntax/blueprint'

class BlueprintSyntaxTest < Test::Unit::TestCase

  context "a blueprint" do
    setup do
      Factory.sequence(:email) { |n| "somebody#{n}@example.com" }
      User.blueprint do
        first_name { 'Bill'               }
        last_name  { 'Nye'                }
        email      { Factory.next(:email) }
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

      should "use attributes from the blueprint" do
        assert_equal 'Bill', @instance.first_name
      end

      should "evaluate attribute blocks for each instance" do
        assert_match /somebody\d+@example.com/, @instance.email
        assert_not_equal @instance.email, Factory(:user).email
      end
    end
  end

end

