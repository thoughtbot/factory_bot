module FactoryGirl

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  class Sequence
    attr_reader :name, :names, :value

    def initialize(*names, &proc) #:nodoc:
      names.flatten!
      @value  = value?(names.last) ? names.slice!(-1) : 1
      @names  = names
      @name   = names.first
      @proc   = proc      
    end

    def next
      @proc ? @proc.call(@value) : @value
    ensure
      @value = @value.next
    end

    private

    def value? item
      item.is_a?(Numeric) || item.is_a?(String)
    end
  end
end
