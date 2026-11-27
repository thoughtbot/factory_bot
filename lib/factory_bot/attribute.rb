require "factory_bot/attribute/dynamic"
require "factory_bot/attribute/association"
require "factory_bot/attribute/sequence"

module FactoryBot
  # @api private
  class Attribute
    attr_reader :name, :transient

    def initialize(name, transient)
      @name = name.to_sym
      @transient = transient
    end

    def to_proc
      -> {}
    end

    def association?
      false
    end

    def alias_for?(attr)
      FactoryBot.aliases_for(attr).include?(name)
    end

    # A copy that is evaluated but never assigned, for a redefinition of a
    # transient attribute outside a transient block.
    def as_transient
      dup.tap { |attribute| attribute.transient = true }
    end

    protected

    attr_writer :transient
  end
end
