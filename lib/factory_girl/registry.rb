module FactoryGirl
  class Registry
    include Enumerable

    def initialize(name)
      @name  = name
      @items = {}
    end

    def register(name, item)
      if registered?(name)
        raise DuplicateDefinitionError, "#{@name} already registered: #{name}"
      else
        @items[name.to_sym] = item
      end
    end

    def find(name)
      @items[name.to_sym] or raise ArgumentError.new("#{@name} not registered: #{name.to_s}")
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def [](name)
      find(name)
    end

    def registered?(name)
      @items.key?(name.to_sym)
    end

    def clear
      @items.clear
    end
  end
end
