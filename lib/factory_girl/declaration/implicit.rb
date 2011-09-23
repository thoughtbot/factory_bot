module FactoryGirl
  class Declaration
    class Implicit < Declaration
      def initialize(name, factory = nil)
        super(name)
        @factory = factory
      end

      private

      def build
        if FactoryGirl.factories.registered?(name)
          [Attribute::Association.new(name, name, {})]
        elsif FactoryGirl.sequences.registered?(name)
          [Attribute::Sequence.new(name, name)]
        else
          trait_root = @factory || FactoryGirl
          trait_root.trait_by_name(name).attributes.to_a
        end
      end
    end
  end
end
