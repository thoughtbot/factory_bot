module FactoryGirl
  class Declaration
    class Dynamic < Declaration
      def initialize(name, block)
        super(name)
        @block = block
      end

      private

      def build
        [Attribute::Dynamic.new(name, @block)]
      end
    end
  end
end
