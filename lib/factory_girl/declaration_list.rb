module FactoryGirl
  class DeclarationList
    def initialize
      @declarations = []
    end

    def to_attributes
      @declarations.inject([]) {|result, declaration| result += declaration.to_attributes }
    end

    def method_missing(name, *args, &block)
      @declarations.send(name, *args, &block)
    end
  end
end
