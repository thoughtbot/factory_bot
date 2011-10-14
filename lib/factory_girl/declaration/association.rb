module FactoryGirl
  class Declaration
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
        factory_name = @options.delete(:factory) || name
        [Attribute::Association.new(name, factory_name, @options)]
      end
    end
  end
end
