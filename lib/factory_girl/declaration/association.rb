module FactoryGirl
  class Declaration
    # @api private
    class Association < Declaration
      def initialize(name, options)
        super(name, false)
        @options = options
      end

      def ==(other)
        name == other.name &&
          options == other.options
      end

      protected
      attr_reader :options

      private

      def build
        factory_name = @options[:factory] || name
        [Attribute::Association.new(name, factory_name, @options.except(:factory))]
      end
    end
  end
end
