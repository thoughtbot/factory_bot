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
        class_name = @overrides[:class_name]
        [Attribute::Association.new(name, factory_name, [@traits, @overrides.except(:factory, :class_name)].flatten, class_name)]
      end
    end
  end
end
