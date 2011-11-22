module FactoryGirl
  class Attribute

    class Sequence < Attribute
      def initialize(name, sequence, ignored)
        super(name, ignored)
        @sequence = sequence
      end

      def to_proc(proxy)
        sequence = @sequence
        lambda { FactoryGirl.generate(sequence) }
      end
    end

  end
end
