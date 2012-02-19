module FactoryGirl
  class Declaration
    class AssociationList < Declaration
      def initialize(name, amount, options)
        super(name, false)
        @amount = amount
        @options = options
      end

      def ==(other)
        name == other.name &&
          amount == other.amount &&
          options == other.options
      end

      protected
      attr_reader :amount, :options

      private

      def build
        # XXX: name.singularize may not be sufficient, ideally we should inflect on the association if the model is activerecord.
        factory_name = @options.delete(:factory) || name.to_s.singularize
        [Attribute::AssociationList.new(name, amount, factory_name, @options)]
      end
    end
  end
end
