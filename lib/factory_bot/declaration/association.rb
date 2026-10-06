module FactoryBot
  class Declaration
    # @api private
    class Association < Declaration
      attr_reader :factory_name, :overrides, :traits

      def initialize(name, *options)
        super(name, false)
        @options = options.dup
        @overrides = options.extract_options!
        @factory_name = @overrides.delete(:factory) || name
        @traits = options
      end

      def ==(other)
        self.class == other.class &&
          name == other.name &&
          options == other.options
      end

      protected

      attr_reader :options
    end
  end
end
