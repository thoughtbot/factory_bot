require "factory_girl/declaration/static"
require "factory_girl/declaration/dynamic"
require "factory_girl/declaration/association"
require "factory_girl/declaration/implicit"

module FactoryGirl
  class Declaration
    attr_reader :name

    def initialize(name, ignored = false)
      @name    = name
      @ignored = ignored
    end

    def to_attributes
      build
    end

    protected
    attr_reader :ignored
  end
end
