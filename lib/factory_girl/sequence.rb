module FactoryGirl

  # Raised when calling Factory.sequence from a dynamic attribute block
  class SequenceAbuseError < StandardError; end

  # Sequences are defined using Factory.sequence. Sequence values are generated
  # using next.
  class Sequence

    def initialize(value = 1, &proc) #:nodoc:
      @proc  = proc
      @value = value || 1 
    end

    # Returns the next value for this sequence
    def next
      @proc.call(@value)
    ensure
      @value = @value.next
    end

  end

  class << self
    attr_accessor :sequences #:nodoc:
  end
  self.sequences = {}
end
