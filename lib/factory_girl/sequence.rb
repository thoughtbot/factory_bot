module FactoryGirl

  # Raised when calling Factory.sequence from a dynamic attribute block
  class SequenceAbuseError < StandardError; end

  # Sequences are defined using Factory.sequence. Sequence values are generated
  # using next.
  class Sequence

    def initialize(&proc) #:nodoc:
      @proc  = proc
      @value = 0
    end

    # Returns the next value for this sequence
    def next
      @value += 1
      @proc.call(@value)
    end

  end

  class << self
    attr_accessor :sequences #:nodoc:
  end
  self.sequences = {}
end
