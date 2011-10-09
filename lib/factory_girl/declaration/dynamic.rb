module FactoryGirl
  class Declaration
    class Dynamic < Declaration
      def initialize(name, ignored = false, block = nil)
        super(name, ignored)
        @block = block
      end

      private

      def build
        [Attribute::Dynamic.new(name, @ignored, @block)]
      end
    end
  end
end
