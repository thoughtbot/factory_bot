module FactoryGirl
  class DeclarationList
    def initialize
      @definitions = []
    end

    def to_attributes
      @definitions.inject([]) {|result, definition| result += definition.to_attributes }
    end

    def method_missing(name, *args, &block)
      @definitions.send(name, *args, &block)
    end
  end
end
