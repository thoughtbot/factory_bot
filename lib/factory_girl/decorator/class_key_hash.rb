module FactoryGirl
  class Decorator
    class ClassKeyHash < Decorator
      def [](key)
        @component[symbolized_key key]
      end

      def []=(key, value)
        @component[symbolized_key key] = value
      end

      def key?(key)
        @component.key? symbolized_key(key)
      end

      private

      def symbolized_key(key)
        if key.respond_to?(:to_sym)
          key.to_sym
        else
          key.to_s.underscore.to_sym
        end
      end
    end
  end
end
