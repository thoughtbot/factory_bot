module FactoryGirl
  class Declaration
    class Static < Declaration
      def initialize(name, value)
        super(name)
        @value = value
      end

      private

      def build
        [Attribute::Static.new(name, @value)]
      end
    end
  end
end
