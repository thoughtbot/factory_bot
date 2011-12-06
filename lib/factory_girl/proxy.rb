require "active_support/core_ext/hash/except"
require "factory_girl/proxy/build"
require "factory_girl/proxy/create"
require "factory_girl/proxy/attributes_for"
require "factory_girl/proxy/stub"

module FactoryGirl
  class Proxy #:nodoc:
    def initialize(evaluator_class_definer, klass, callbacks = [], overrides = {})
      @callbacks = callbacks
      @klass     = klass
      @overrides = overrides

      @evaluator_class_definer = evaluator_class_definer
    end

    def run_callbacks(name)
      @callbacks.select {|callback| callback.name == name }.each do |callback|
        callback.run(result_instance, evaluator)
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

    def result_instance
      attribute_assigner.object
    end

    def result_hash
      attribute_assigner.hash
    end

    def evaluator
      @evaluator ||= @evaluator_class_definer.evaluator_class.new(self, @overrides)
    end

    def attribute_assigner
      @attribute_assigner ||= AttributeAssigner.new(@klass, evaluator, @evaluator_class_definer.attributes)
    end
  end
end
