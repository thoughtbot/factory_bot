module FactoryGirl
  class Declaration
    # @api private
    class Association < Declaration
      def initialize(name, options)
        super(name, false)
        @traits  = options.delete(:traits)
        @options = options
      end

      def ==(other)
        name == other.name &&
          traits == other.traits &&
          options == other.options
      end

      protected
      attr_reader :traits, :options

      private

      def build
        factory_name = @options[:factory] || name
        traits_and_options = [@traits, @options.except(:factory)].compact.flatten
        [Attribute::Association.new(name, factory_name, traits_and_options)]
      end
    end
  end
end
