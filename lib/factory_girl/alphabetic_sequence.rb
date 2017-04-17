module FactoryGirl
  class AlphabeticSequence < Sequence
    private

    def initial_value
      "000000000000"
    end

    def increment_value
      previous = value
      super
      raise SequenceOverflowError if value < previous
    end
  end
end
