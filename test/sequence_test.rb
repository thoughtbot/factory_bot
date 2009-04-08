require 'test_helper'

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

  context "defining a sequence" do

    setup do
      @sequence = "sequence"
      @name     = :count
      stub(Factory::Sequence).new { @sequence }
    end

    should "create a new sequence" do
      mock(Factory::Sequence).new() { @sequence }
      Factory.sequence(@name)
    end

    should "use the supplied block as the sequence generator" do
      stub(Factory::Sequence).new.yields(1)
      yielded = false
      Factory.sequence(@name) {|n| yielded = true }
      assert yielded
    end

  end

  context "after defining a sequence" do

    setup do
      @sequence = "sequence"
      @name     = :test
      @value    = '1 2 5'

      stub(@sequence).next { @value }
      stub(Factory::Sequence).new { @sequence }

      Factory.sequence(@name) {}
    end

    should "call next on the sequence when sent next" do
      mock(@sequence).next

      Factory.next(@name)
    end

    should "return the value from the sequence" do
      assert_equal @value, Factory.next(@name)
    end

  end

end
