module FactoryGirl
  class Attribute

    class Sequence < Attribute
      def initialize(name, sequence, ignored)
        super(name, ignored)
        @sequence = sequence
      end

      def add_to(proxy)
        value = FactoryGirl.generate(@sequence)
        if @ignored
          proxy.set_ignored(name, value)
        else
          proxy.set(name, value)
        end
      end
    end

  end
end
