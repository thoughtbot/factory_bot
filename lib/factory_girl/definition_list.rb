module FactoryGirl
  class DefinitionList
    include Enumerable

    def initialize(definitions = [])
      @definitions = definitions
    end

    def each(&block)
      @definitions.each &block
    end

    def callbacks
      map(&:callbacks).flatten
    end

    def attributes
      map {|definition| definition.attributes.to_a }.flatten
    end

    def to_create
      map(&:to_create).compact.last
    end

    def constructor
      map(&:constructor).compact.last
    end

    delegate :[], :==, to: :@definitions
  end
end
