module FactoryBot
  class Declaration
    # @api private
    class Dynamic < Declaration
      attr_reader :block

      def initialize(name, transient = false, block = nil)
        super(name, transient)
        @block = block
      end

      def ==(other)
        self.class == other.class &&
          name == other.name &&
          transient == other.transient &&
          block == other.block
      end
    end
  end
end
