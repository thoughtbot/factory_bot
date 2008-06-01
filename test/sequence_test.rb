require(File.join(File.dirname(__FILE__), 'test_helper'))

class SequenceTest < Test::Unit::TestCase

  context "a sequence" do

    setup do
      @sequence = Factory::Sequence.new {|n| "=#{n}" }
    end

    should "start with a value of 1" do
      assert_equal "=1", @sequence.next
    end

    context "after being called" do

      setup do
        @sequence.next
      end

      should "use the next value" do
        assert_equal "=2", @sequence.next
      end

    end

  end

end
