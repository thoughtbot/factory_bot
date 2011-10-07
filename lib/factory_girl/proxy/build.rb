module FactoryGirl
  class Proxy #:nodoc:
    class Build < Proxy #:nodoc:
      def initialize(klass)
        super(klass)
        @instance = klass.new
      end

      def get(attribute)
        if @ignored_attributes.has_key?(attribute)
          @ignored_attributes[attribute]
        else
          @instance.send(attribute)
        end
      end

      def set(attribute, value)
        @instance.send(:"#{attribute}=", value)
      end

      def associate(name, factory_name, overrides)
        method = get_method(overrides[:method])
        factory = FactoryGirl.factory_by_name(factory_name)
        set(name, factory.run(method, remove_method(overrides)))
      end

      def association(factory_name, overrides = {})
        method = get_method(overrides[:method])
        factory = FactoryGirl.factory_by_name(factory_name)
        factory.run(method, remove_method(overrides))
      end

      def remove_method(overrides)
        overrides.dup.delete_if {|key, value| key == :method}
      end

      def result(to_create)
        run_callbacks(:after_build)
        @instance
      end

      def parse_method(method)
        method ||= :create
        if :build == method
          return Proxy::Build
        elsif :create == method
          return Proxy::Create
        else
          raise "unrecognized method #{method}"
        end
      end

      alias_method :get_method, :parse_method
    end
  end
end
