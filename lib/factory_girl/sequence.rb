module FactoryGirl

  # Raised when calling Factory.sequence from a dynamic attribute block
  class SequenceAbuseError < StandardError; end

  # Sequences are defined using Factory.sequence. Sequence values are generated
  # using next.
  class Sequence

    def initialize(value = 1, enum = nil, &proc) #:nodoc:
      @enum = enum.to_a if(!enum.nil?)
      @enum_idx = 0
      @proc  = proc
      @value = value || 1
    end

    # Returns the next value for this sequence
    def next
      begin
        retval = case @proc.arity
          when 1
            # let us handle when we pass just an array
            if(@value.class == Array)
              @enum = @value
              @value = 1
            end
            @enum ? @proc.call(@enum[@enum_idx]) : @proc.call(@value) 
          when 2
            @proc.call(@enum[@enum_idx], @value)
        end
      ensure
        if @enum
          @enum_idx = (@enum_idx+1 == @enum.size) ? 0 : @enum_idx+1
        end
        @value = @value.next
      end
      retval
    end

  end

  class << self
    attr_accessor :sequences #:nodoc:
  end
  self.sequences = {}
end
