module FactoryGirl
  class Attribute

    class Sequence < Attribute
      def initialize(name, sequence, ignored)
        super(name, ignored)
        @sequence = sequence
      end

      def add_to(proxy)
        value = FactoryGirl.generate(@sequence)
        set_proxy_value(proxy, value)
      end
    end

  end
end
