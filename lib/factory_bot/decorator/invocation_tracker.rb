module FactoryBot
  class Decorator
    class InvocationTracker < Decorator
      def initialize(component)
        super
        @invoked_methods = []
      end

      if ::Gem::Version.new(::RUBY_VERSION) >= ::Gem::Version.new("2.7")
        def method_missing(name, *args, **kwargs, &block) # rubocop:disable Style/MissingRespondToMissing
          @invoked_methods << name
          super
        end
      else
        def method_missing(name, *args, &block) # rubocop:disable Style/MissingRespondToMissing
          @invoked_methods << name
          super
        end
      end

      def __invoked_methods__
        @invoked_methods.uniq
      end
    end
  end
end
