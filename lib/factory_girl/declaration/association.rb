module FactoryGirl
  class Declaration
    class Association < Declaration
      def initialize(name, options)
        super(name, false)
        @options = options
      end

      private

      def build
        factory_name = @options.delete(:factory) || name
        [Attribute::Association.new(name, factory_name, @options)]
      end
    end
  end
end
