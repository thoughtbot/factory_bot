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
        overrides = [@traits, @overrides.except(:factory)].flatten
        [Attribute::Association.new(name, @ignored, factory_name, overrides)]
      end
    end
  end
end
