module FactoryBot
  class Decorator < BasicObject
    undef_method :==

    def initialize(component)
      @component = component
    end

    if ::Gem::Version.new(::RUBY_VERSION) >= ::Gem::Version.new("2.7")
      class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          def method_missing(...) # rubocop:disable Style/MethodMissingSuper, Style/MissingRespondToMissing
          @component.send(...)
        end

        def send(...)
          __send__(...)
        end
      RUBY
    else
      def method_missing(name, *args, &block) # rubocop:disable Style/MethodMissingSuper, Style/MissingRespondToMissing
        @component.send(name, *args, &block)
      end

      def send(symbol, *args, &block)
        __send__(symbol, *args, &block)
      end
    end

    def respond_to_missing?(name, include_private = false)
      @component.respond_to?(name, true) || super
    end

    def self.const_missing(name)
      ::Object.const_get(name)
    end
  end
end
