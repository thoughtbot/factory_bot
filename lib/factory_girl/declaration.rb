module FactoryGirl
  class Declaration
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def ignore
      @ignored = true
    end

    def to_attributes
      build.tap do |attributes|
        attributes.each(&:ignore) if @ignored
      end
    end
  end
end
