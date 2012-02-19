module FactoryGirl
  class Attribute #:nodoc:
    class AssociationList < Attribute  #:nodoc:
      attr_reader :factory

      def initialize(name, amount, factory, overrides)
        super(name, false)
        @amount = amount
        @factory = factory
        @overrides = overrides
      end

      def to_proc
        amount = @amount
        factory = @factory
        overrides = @overrides
        lambda { association_list(factory, amount, overrides) }
      end

      def association?
        true
      end
    end
  end
end
