require "active_support/core_ext/hash/except"
require "factory_girl/proxy/build"
require "factory_girl/proxy/create"
require "factory_girl/proxy/attributes_for"
require "factory_girl/proxy/stub"

module FactoryGirl
  class Proxy #:nodoc:
    def initialize(klass, callbacks = [])
      @callbacks = process_callbacks(callbacks)
      @proxy     = ObjectWrapper.new(klass)
    end

    delegate :get, :set, :set_ignored, :to => :@proxy

    def run_callbacks(name)
      if @callbacks[name]
        @callbacks[name].each do |callback|
          callback.run(result_instance, self)
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

    def result(to_create)
      raise NotImplementedError, "Strategies must return a result"
    end

    def self.ensure_strategy_exists!(strategy)
      unless Proxy.const_defined? strategy.to_s.camelize
        raise ArgumentError, "Unknown strategy: #{strategy}"
      end
    end

    private

    def method_missing(method, *args, &block)
      get(method)
    end

    def process_callbacks(callbacks)
      callbacks.inject({}) do |result, callback|
        result[callback.name] ||= []
        result[callback.name] << callback
        result
      end
    end

    def result_instance
      @proxy.object
    end

    def result_hash
      @proxy.to_hash
    end

    class ObjectWrapper
      def initialize(klass)
        @klass      = klass
        @attributes = []
        @cached_attribute_values = {}
      end

      def to_hash
        @attributes.inject({}) do |result, attribute|
          result[attribute] = get(attribute)
          result
        end
      end

      def object
        @object ||= @klass.new
        assign_object_attributes
        @object
      end

      def set(attribute, value)
        define_attribute(attribute, value)
        @attributes << attribute.name
      end

      def set_ignored(attribute, value)
        define_attribute(attribute, value)
      end

      def get(attribute)
        @cached_attribute_values[attribute] ||= anonymous_instance.send(attribute)
      end

      private

      def define_attribute(attribute, value)
        anonymous_class.send(:define_method, attribute.name, value)
      end

      def assign_object_attributes
        (@attributes - @cached_attribute_values.keys).each do |attribute|
          @object.send("#{attribute}=", get(attribute))
        end
      end

      def anonymous_class
        @anonymous_class ||= Class.new
      end

      def anonymous_instance
        @anonymous_instance ||= anonymous_class.new
      end
    end
  end
end
