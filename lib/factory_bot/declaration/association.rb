module FactoryBot
  class Declaration
    # @api private
    class Association < Declaration
      def initialize(name, *options)
        super(name, false)
        @options = options.dup
        @overrides = options.extract_options!
        @traits = options
      end

      def ==(other)
        self.class == other.class &&
          name == other.name &&
          options == other.options
      end

      protected

      attr_reader :options

      private

      def build
        ensure_factory_is_not_a_declaration!

        factory_name = @overrides[:factory] || name
        [Attribute::Association.new(name, factory_name, [@traits, @overrides.except(:factory)].flatten)]
      end

      def ensure_factory_is_not_a_declaration!
        if @overrides[:factory].is_a?(Declaration)
          raise ArgumentError.new(<<~MSG)
            Association '#{name}' received an invalid factory argument.
            Did you mean? 'factory: :#{@overrides[:factory].name}'
          MSG
        end
      end
    end
  end
end
