module FactoryBot
  class Declaration
    # @api private
    class Association < Declaration
      def initialize(name, *options, **overrides)
        super(name, false)
        @options = options.dup
        @overrides = overrides.dup
        @factory_name = @overrides.delete(:factory) || name
        @traits = options
      end

      def ==(other)
        self.class == other.class &&
          name == other.name &&
          options == other.options &&
          overrides == other.overrides
      end

      protected

      attr_reader :options, :overrides

      private

      attr_reader :factory_name, :traits

      def build
        raise_if_arguments_are_declarations!

        [
          Attribute::Association.new(
            name,
            factory_name,
            [traits, overrides].flatten
          )
        ]
      end

      def raise_if_arguments_are_declarations!
        if factory_name.is_a?(Declaration)
          raise ArgumentError.new(<<~MSG)
            Association '#{name}' received an invalid factory argument.
            Did you mean? 'factory: :#{factory_name.name}'
          MSG
        end

        overrides.each do |attribute, value|
          if value.is_a?(Declaration)
            raise ArgumentError.new(<<~MSG)
              Association '#{name}' received an invalid attribute override.
              Did you mean? '#{attribute}: :#{value.name}'
            MSG
          end
        end
      end
    end
  end
end
