module FactoryBot
  class Declaration
    # @api private
    class Association < Declaration
      def initialize(name, ignored, *options)
        super(name, ignored)
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
        factory_name = @overrides[:factory] || name
        [Attribute::Association.new(name, @ignored, factory_name, [@traits, @overrides.except(:factory)].flatten)]
      end
    end
  end
end
