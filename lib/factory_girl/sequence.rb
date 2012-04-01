module FactoryGirl

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  class Sequence
    attr_reader :name, :names, :value

    def initialize(name, value = 1, options = {}, &proc) #:nodoc:
      @value  = value
      if value.kind_of?(Hash)
        options = value
        @value = options[:value] || 1
      end      
      @name   = name
      @names  = ([name] + (options[:aliases] || [])).flatten
      @proc   = proc     
    end

    # aliased sequences share the same sequence counter
    def next
      @proc ? @proc.call(@value) : @value
    ensure
      @value = @value.next
    end
  end
end
