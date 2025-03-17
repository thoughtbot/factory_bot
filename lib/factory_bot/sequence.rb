module FactoryBot
  # Sequences are defined using sequence within a FactoryBot.define block.
  # Sequence values are generated using next.
  # @api private
  class Sequence
    attr_reader :name

    def initialize(name, *args, &proc)
      @name = name
      @proc = proc

      options = args.extract_options!
      @value = args.first || 1
      @aliases = options.fetch(:aliases) { [] }
      @lazy_value_proc = options.fetch(:lazy) { nil }

      if @lazy_value_proc
        raise ArgumentError.new("The 'lazy' argument value must be a Proc") unless @lazy_value_proc.is_a?(Proc)

        @value = LazyEnumeratorAdapter.new(&@lazy_value_proc)
      elsif !@value.respond_to?(:peek)
        @value = EnumeratorAdapter.new(@value)
      end
    end

    def next(scope = nil)
      if @proc && scope
        scope.instance_exec(value, &@proc)
      elsif @proc
        @proc.call(value)
      else
        value
      end
    ensure
      increment_value
    end

    def names
      [@name] + @aliases
    end

    def rewind
      @value.rewind
    end

    private

    def value
      @value.peek
    end

    def increment_value
      @value.next
    end

    class EnumeratorAdapter
      def initialize(value)
        @first_value = value
        @value = value
      end

      def peek
        @value
      end

      def next
        @value = @value.next
      end

      def rewind
        @value = @first_value
      end
    end

    class LazyEnumeratorAdapter
      def initialize(&proc)
        @proc = proc
        @loaded = false
      end

      def peek
        value
      end

      def next
        @value = value.next
      end

      def rewind
        @value = first_value
      end

      private

      def first_value
        load_initial_value unless loaded?

        @first_value
      end

      def value
        load_initial_value unless loaded?

        @value
      end

      def load_initial_value
        @value = @proc.call
        @first_value = @value
        @loaded = true
      end

      def loaded?
        @loaded
      end
    end
  end
end
