module FactoryGirl
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
        name == other.name &&
          options == other.options
      end

      protected
      attr_reader :options

      private

      def build
        factory_name = @overrides[:factory] || name
        class_override = @overrides[:class]
        [Attribute::Association.new(name, factory_name, [@traits, @overrides.except(:factory, :class)].flatten, class_override)]
      end
    end
  end
end
