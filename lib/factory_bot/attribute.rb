require "factory_girl/attribute/dynamic"
require "factory_girl/attribute/association"
require "factory_girl/attribute/sequence"

module FactoryGirl
  # @api private
  class Attribute
    attr_reader :name, :ignored

    def initialize(name, ignored)
      @name = name.to_sym
      @ignored = ignored
    end

    def to_proc
      -> {}
    end

    def association?
      false
    end

    def alias_for?(attr)
      FactoryGirl.aliases_for(attr).include?(name)
    end
  end
end
