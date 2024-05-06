module FactoryBot
  class ScopedSequence
    attr_reader :name, :scope_name

    def initialize(name, scope_name, *args, &proc)
      @name = name
      @scope_name = scope_name
      @proc = proc

      options = args.extract_options!
      @default_value = args.first || 1
      @aliases = options.fetch(:aliases) { [] }
      @scopes = []
    end

    def next(scope_value, scope = nil)
      value = value(scope_value)
      if @proc && scope
        scope.instance_exec(value, &@proc)
      elsif @proc
        @proc.call(value)
      else
        value
      end
    ensure
      increment_value(scope_value)
    end

    def names
      [@name] + @aliases
    end

    def rewind
      @scopes.each(&:rewind)
    end

    private

    def value_by_scope(scope_value)
      @scopes.find { |scope| scope.scope_value == scope_value } || initialized_scope(scope_value)
    end

    def initialized_scope(scope_value)
      @scopes << new_scope = ScopedEnumeratorAdapter.new(scope_value, @default_value.dup)
      new_scope
    end

    def value(scope_value)
      value_by_scope(scope_value).peek
    end

    def increment_value(scope_value)
      value_by_scope(scope_value).next
    end

    class ScopedEnumeratorAdapter
      attr_reader :scope_value

      delegate :peek, :next, :rewind, to: :@value

      def initialize(scope_value, value)
        @scope_value = scope_value
        @value =
          if value.respond_to?(:peek)
            value
          else
            Sequence::EnumeratorAdapter.new(value)
          end
      end
    end
  end
end
