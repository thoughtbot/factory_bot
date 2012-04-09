module FactoryGirl

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  class Sequence
    attr_reader :name

    def initialize(name, value = 1, &proc) #:nodoc:
      @name  = name
      @proc  = proc
      @value = [Array, Range].any? {|klass| value.is_a? klass } ? value.to_enum : value
    end

    def next
      value = @value.is_a?(Enumerator) ? @value.next : @value
      @proc ? @proc.call(value) : value
    ensure
      @value = @value.next unless @value.is_a?(Enumerator)
    end

    def names
      [@name]
    end
  end
end
