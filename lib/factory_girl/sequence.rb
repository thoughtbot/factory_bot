module FactoryGirl

  # Sequences are defined using sequence within a FactoryGirl.define block.
  # Sequence values are generated using next.
  # @api private
  class Sequence
    attr_reader :name

    def initialize(name, *args, &proc)
      @name    = name
      @proc    = proc

      options  = args.extract_options!
      @value   = args.first || 1
      @aliases = options.fetch(:aliases) { [] }
    end

    def next
      @proc ? @proc.call(current_value) : current_value
    ensure
      increment_value
    end

    def names
      [@name] + @aliases
    end

    private

    def current_value
      @value.is_a?(Enumerator) ? @value.peek : @value
    end

    def increment_value
      if @value.is_a?(Enumerator)
        @value.next
      else
        @value = @value.next
      end
    end
  end
end
