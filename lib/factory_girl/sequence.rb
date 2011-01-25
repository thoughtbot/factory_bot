module FactoryGirl

  # Raised when calling Factory.sequence from a dynamic attribute block
  class SequenceAbuseError < StandardError; end

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  class Sequence
    def initialize(name, value = 1, &proc) #:nodoc:
      @name = name
      @proc  = proc
      @value = value || 1
    end

    # Returns the next value for this sequence
    def run(proxy_class = nil, overrides = {})
      @proc ? @proc.call(@value) : @value
    ensure
      @value = @value.next
    end

    def next
      puts "WARNING: FactoryGirl::Sequence#next is deprecated."
      puts "Use #run instead."
      run
    end

    def default_strategy
      :create
    end

    def names
      [@name]
    end
  end

  def self.sequences
    puts "WARNING: FactoryGirl.sequences is deprecated."
    puts "Use FactoryGirl.registry instead."
    registry
  end
end
