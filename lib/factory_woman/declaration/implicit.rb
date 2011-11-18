module FactoryWoman
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
        if FactoryWoman.factories.registered?(name)
          [Attribute::Association.new(name, name, {})]
        elsif FactoryWoman.sequences.registered?(name)
          [Attribute::Sequence.new(name, name, @ignored)]
        else
          @factory.inherit_traits([name])
          []
        end
      end
    end
  end
end
