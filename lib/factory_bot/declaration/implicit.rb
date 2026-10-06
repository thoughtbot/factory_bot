module FactoryBot
  class Declaration
    # @api private
    class Implicit < Declaration
      attr_reader :factory

      def initialize(name, factory = nil, transient = false)
        super(name, transient)
        @factory = factory
      end

      def ==(other)
        self.class == other.class &&
          name == other.name &&
          factory == other.factory &&
          transient == other.transient
      end
    end
  end
end
