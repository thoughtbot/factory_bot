require "active_support/core_ext/hash/except"
require "factory_girl/proxy/build"
require "factory_girl/proxy/create"
require "factory_girl/proxy/attributes_for"
require "factory_girl/proxy/stub"

module FactoryGirl
  class Proxy #:nodoc:
    def initialize(klass, callbacks = [])
      @callbacks = callbacks.inject({}) do |result, callback|
        result[callback.name] ||= []
        result[callback.name] << callback
        result
      end

      @instance = NullInstanceWrapper.new
    end

    def get(attribute)
      @instance.get(attribute)
    end

    def set(attribute, value)
      @instance.set(attribute.name, value)
    end

    def set_ignored(attribute, value)
      @instance.set_ignored(attribute.name, value)
    end

    def run_callbacks(name)
      if @callbacks[name]
        @callbacks[name].each do |callback|
          callback.run(@instance.object, self)
        end
      end
    end

    # Generates an association using the current build strategy.
    #
    # Arguments:
    #   name: (Symbol)
    #     The name of the factory that should be used to generate this
    #     association.
    #   attributes: (Hash)
    #     A hash of attributes that should be overridden for this association.
    #
    # Returns:
    #   The generated association for the current build strategy. Note that
    #   associations are not generated for the attributes_for strategy. Returns
    #   nil in this case.
    #
    # Example:
    #
    #   factory :user do
    #     # ...
    #   end
    #
    #   factory :post do
    #     # ...
    #     author { |post| post.association(:user, :name => 'Joe') }
    #   end
    #
    #   # Builds (but doesn't save) a Post and a User
    #   FactoryGirl.build(:post)
    #
    #   # Builds and saves a User, builds a Post, assigns the User to the
    #   # author association, and saves the Post.
    #   FactoryGirl.create(:post)
    #
    def association(name, overrides = {})
    end

    def method_missing(method, *args, &block)
      get(method)
    end

    def result(to_create)
      raise NotImplementedError, "Strategies must return a result"
    end

    def self.ensure_strategy_exists!(strategy)
      unless Proxy.const_defined? strategy.to_s.camelize
        raise ArgumentError, "Unknown strategy: #{strategy}"
      end
    end

    class InstanceWrapper
      attr_reader :object
      def initialize(object = nil)
        @object             = object
        @ignored_attributes = {}
      end

      def set_ignored(attribute, value)
        @ignored_attributes[attribute] = value
      end

      def get(attribute)
        if @ignored_attributes.has_key?(attribute)
          @ignored_attributes[attribute]
        else
          get_attr(attribute)
        end
      end
    end

    class NullInstanceWrapper < InstanceWrapper
      def get_attr(attribute);   end
      def set(attribute, value); end
    end

    class ClassInstanceWrapper < InstanceWrapper
      def get_attr(attribute);   @object.send(attribute);               end
      def set(attribute, value); @object.send(:"#{attribute}=", value); end
    end

    class HashInstanceWrapper < InstanceWrapper
      def get_attr(attribute);   @object[attribute];         end
      def set(attribute, value); @object[attribute] = value; end
    end
  end
end
