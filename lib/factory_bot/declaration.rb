require "factory_bot/declaration/dynamic"
require "factory_bot/declaration/association"
require "factory_bot/declaration/implicit"

module FactoryBot
  # An attribute as declared in a factory or trait block. Compiler turns it
  # into an Attribute.
  # @api private
  class Declaration
    attr_reader :name, :transient

    def initialize(name, transient = false)
      @name = name
      @transient = transient
    end
  end
end
