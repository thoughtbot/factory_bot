require "timeout"

module FactoryBot
  # Sequences are defined using sequence within a FactoryBot.define block.
  # Sequence values are generated using next.
  # @api private
  class Sequence
    attr_reader :name, :uri_mgr, :aliases

    @sequence_setting_timeout = nil

    # = Class Methods
    # ======================================================================

    ##
    # Find a sequence by context and name.
    #
    # Arguments:
    #   uri_parts: (Array of Strings or Symbols)
    #             comprises the sequence URI parts
    #
    # Example:
    #   Sequence.find :my_factory, :my_trait, :my_sequence
    #
    def self.find(*uri_parts)
      if uri_parts.empty?
        fail ArgumentError, "wrong number of arguments, expected 1+)"
      else
        find_by_uri FactoryBot::UriManager.build_uri(*uri_parts)
      end
    end

    ##
    # Find a sequence by URI. Searches both Global and inline sequences.
    #
    # Arguments:
    #   uri: (Symbol)
    #     The uri name to search for
    #
    def self.find_by_uri(uri)
      uri = uri.to_sym
      (FactoryBot::Internal.sequences.to_a.find { |seq| seq.has_uri?(uri) }) ||
        (FactoryBot::Internal.inline_sequences.find { |seq| seq.has_uri?(uri) })
    end

    ##
    # Returns the number of seconds to allow for setting sequence.
    # Defaults to 3 seconds, but can be overriden with an
    # environment variable 'FACTORY_BOT_SET_SEQUENCE_TIMEOUT'
    #
    def self.sequence_setting_timeout
      @sequence_setting_timeout ||= begin
        user_time = ENV["FACTORY_BOT_SET_SEQUENCE_TIMEOUT"].to_f
        (user_time >= 0.1) ? user_time : 3
      rescue
        3
      end
    end

    # = Instance Methods
    # ======================================================================

    def initialize(name, *args, &proc)
      options = args.extract_options!
      @name = name
      @proc = proc
      @aliases = options.fetch(:aliases, []).map(&:to_sym)
      @uri_mgr = FactoryBot::UriManager.new(names, paths: options[:uri_paths])
      @value = args.first || 1

      unless @value.respond_to?(:peek)
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

    def has_name?(test_name)
      names.include?(test_name.to_sym)
    end

    def has_uri?(uri)
      uri_mgr.include?(uri)
    end

    def for_factory?(test_factory_name)
      FactoryBot::Internal.factory_by_name(factory_name).names.include?(test_factory_name.to_sym)
    end

    def rewind
      @value.rewind
    end

    ##
    # If it's an Integer based sequence, set the new value directly,
    # else rewind and seek from the beginning until a match is found.
    #
    def set_value(new_val)
      if can_set_value_directly?(new_val)
        @value.set_value(new_val)
      elsif can_set_value_by_index?
        set_value_by_index(new_val)
      else
        seek_value(new_val)
      end
    end

    protected

    attr_reader :proc

    private

    def value
      @value.peek
    end

    def increment_value
      @value.next
    end

    def can_set_value_by_index?
      @value.respond_to?(:find_index)
    end

    ##
    # Set to the given val, or fail if not found
    #
    def set_value_by_index(val)
      index = @value.find_index(val) || fail_value_not_found(val)
      @value.rewind
      index.times { @value.next }
    end

    ##
    # Rewind index and seek until the value is found or the max attempts
    # have been tried. If not found, the sequence is rewound to its original value
    #
    def seek_value(val)
      original_value = @value.peek

      # rewind and search for the new value
      @value.rewind
      Timeout.timeout(Sequence.sequence_setting_timeout) do
        loop do
          return if @value.peek == val
          increment_value
        end

        # loop auto-recues a StopIteration error, so if we
        # reached this point, re-raise it now
        fail StopIteration
      end
    rescue Timeout::Error, StopIteration
      reset_originl_value(original_value)
      fail_value_not_found(val)
    end

    def reset_originl_value(original_value)
      @value.rewind
      until @value.peek == original_value do increment_value end
    end

    def can_set_value_directly?(val)
      return false unless val.is_a?(Integer)
      return false unless @value.is_a?(EnumeratorAdapter)
      @value.integer_value?
    end

    def fail_value_not_found(val)
      fail ArgumentError, "Unable to find '#{val}' in the sequence."
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

      def set_value(new_val)
        if new_val >= @first_value
          @value = new_val
        else
          fail ArgumentError, "Value cannot be less than: #{@first_value}"
        end
      end

      def integer_value?
        @first_value.is_a?(Integer)
      end
    end
  end
end
