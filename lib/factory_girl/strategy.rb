require "factory_girl/strategy/build"
require "factory_girl/strategy/create"
require "factory_girl/strategy/attributes_for"
require "factory_girl/strategy/stub"
require "observer"

module FactoryGirl
  class Strategy #:nodoc:
    include Observable

    def association(runner)
      raise NotImplementedError, "Strategies must return an association"
    end

    def result(attribute_assigner, to_create)
      raise NotImplementedError, "Strategies must return a result"
    end

    def self.ensure_strategy_exists!(strategy)
      unless Strategy.const_defined? strategy.to_s.camelize
        raise ArgumentError, "Unknown strategy: #{strategy}"
      end
    end

    private

    def run_callbacks(name, result_instance)
      changed
      notify_observers(name, result_instance)
    end
  end
end
