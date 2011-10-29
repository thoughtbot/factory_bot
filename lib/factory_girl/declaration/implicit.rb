module FactoryGirl
  class Declaration
    class Implicit < Declaration
      def initialize(name, factory = nil, ignored = false)
        super(name, ignored)
        @factory = factory
      end

      def ==(other)
        name == other.name &&
          factory == other.factory &&
          ignored == other.ignored
      end

      protected
      attr_reader :factory

      private

      def build
        if FactoryGirl.factories.registered?(name)
          [Attribute::Association.new(name, name, {})]
        elsif FactoryGirl.sequences.registered?(name)
          [Attribute::Sequence.new(name, name, @ignored)]
        else
          @factory.inherit_traits([name])
          []
        end
      end
    end
  end
end
