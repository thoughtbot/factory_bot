module FactoryBot
  class Sequence
    attr_reader :name, :aliases

    # start: a value with #next (1, "a", a Date), an Enumerator, or something
    # callable that produces the starting value on first use.
    def initialize(name, start = 1, aliases: [], &block)
      @name = name.to_sym
      @aliases = aliases.map(&:to_sym)
      @start = start
      @block = block
      @enumerator = nil
    end

    def names
      [name, *aliases]
    end

    def next(scope = nil)
      value = enumerator.next
      return value unless @block
      return scope.instance_exec(value, &@block) if scope

      begin
        @block.call(value)
      rescue NameError
        raise ArgumentError, "Sequence '#{name}' failed to return a value. " \
          "Perhaps it needs a scope to operate? (scope: <object>)"
      end
    end

    def rewind
      @enumerator&.rewind
    end

    private

    def enumerator
      @enumerator ||= begin
        start = @start.respond_to?(:call) ? @start.call : @start
        start.is_a?(Enumerator) ? start : Enumerator.produce(start, &:next)
      end
    end
  end
end
