module FactoryGirl
  class Declaration
    class Static < Declaration
      def initialize(name, value, ignored = false)
        super(name, ignored)
        @value = value
      end

      private

      def build
        [Attribute::Static.new(name, @value, @ignored)]
      end
    end
  end
end
