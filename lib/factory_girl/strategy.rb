class Factory

  class Strategy #:nodoc:
    def initialize(klass)
    end

    def get(attribute)
      nil
    end

    def set(attribute, value)
    end

    def associate(name, factory, attributes)
    end

    def result
      raise NotImplementedError, "Strategies must return a result"
    end
  end

end
