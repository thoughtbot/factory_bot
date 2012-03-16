module FactoryGirl

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  class Sequence
    attr_reader :name

    def initialize(name, value = 1, &proc) #:nodoc:
      @name  = name
      @proc  = proc
      @value = value
    end

    def next
      @proc ? @proc.call(@value) : @value
    ensure
      @value = @value.next
    end

    def names
      [@name]
    end
  end
end
