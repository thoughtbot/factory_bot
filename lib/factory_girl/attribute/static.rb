module FactoryGirl
  class Attribute #:nodoc:

    class Static < Attribute  #:nodoc:

      attr_reader :value

      def initialize(name, value, ignored)
        super(name, ignored)
        @value = value
      end

      def add_to(proxy)
        if @ignored
          proxy.set_ignored(name, @value)
        else
          proxy.set(name, @value)
        end
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
