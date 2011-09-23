module FactoryGirl
  class Attribute #:nodoc:

    class Static < Attribute  #:nodoc:

      attr_reader :value

      def initialize(name, value)
        super(name)
        @value = value
      end

      def add_to(proxy)
        proxy.set(name, @value, @ignored)
      end

      def priority
        0
      end

      def ==(another)
        self.name == another.name &&
          self.value == another.value &&
          self.ignored == another.ignored
      end
    end
  end
end
