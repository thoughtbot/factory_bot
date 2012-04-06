module FactoryGirl

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  class Sequence
    attr_reader :name

    def initialize(name, *args, &proc) #:nodoc:
      @name    = name
      @proc    = proc

      options  = args.extract_options!
      @value   = args.first || 1
      @aliases = options[:aliases] || []
    end

    def next
      @proc ? @proc.call(@value) : @value
    ensure
      @value = @value.next
    end

    def names
      [@name] + @aliases
    end
  end
end
