module FactoryGirl
  class Attribute #:nodoc:
    class Static < Attribute  #:nodoc:
      def initialize(name, value, ignored)
        super(name, ignored)
        @value = value
      end

      def to_proc(proxy)
        value = @value
        lambda { value }
      end
    end
  end
end
