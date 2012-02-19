module FactoryGirl
  class Declaration
    class AssociationList < Declaration
      def initialize(parent_factory_name, name, amount, options)
        super(name, false)
        @parent_factory_name = parent_factory_name
        # XXX: name.singularize may not be sufficient, ideally we should inflect on the association if the model is activerecord.
        @factory_name ||= options.delete(:factory) || name.to_s.singularize
        @amount = amount
        @options = options
      end

      def ==(other)
        name == other.name &&
          amount == other.amount &&
          options == other.options
      end

    protected

      attr_reader :parent_factory_name, :factory_name, :amount, :options

    private

      def build
        [Attribute::AssociationList.new(parent_factory_name, name, amount, factory_name, options)]
      end
    end
  end
end
