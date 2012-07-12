module FactoryGirl
  class DefinitionHierarchy
    def callbacks
      []
    end

    def constructor
      FactoryGirl.constructor
    end

    def to_create
      FactoryGirl.to_create
    end

    def self.add_callbacks(callbacks)
      if callbacks.any?
        define_method :callbacks do
          super() + callbacks
        end
      end
    end

    def self.build_constructor(&block)
      if block
        define_method(:constructor) do
          block
        end
      end
    end

    def self.build_to_create(&block)
      if block
        define_method(:to_create) do
          block
        end
      end
    end
  end
end
