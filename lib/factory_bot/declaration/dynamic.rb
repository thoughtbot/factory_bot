module FactoryBot
  class Declaration
    # @api private
    class Dynamic < Declaration
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

      protected

      attr_reader :block

      private

      def build
        [Attribute::Dynamic.new(name, @transient, @block)]
      end
    end
  end
end
