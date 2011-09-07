module FactoryGirl
  class Declaration
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def ignore
      @ignored = true
    end

    def to_attribute
      build.tap do |attribute|
        attribute.ignore if @ignored
      end
    end
  end
end
