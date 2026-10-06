require "factory_bot/declaration/dynamic"
require "factory_bot/declaration/association"
require "factory_bot/declaration/implicit"

module FactoryBot
  # @api private
  class Declaration
    attr_reader :name

    def initialize(name, transient = false)
      @name = name
      @transient = transient
    end

    def to_attributes
      build
    end

    protected

    attr_reader :transient
  end
end
