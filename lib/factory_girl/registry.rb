module FactoryGirl
  class Registry
    include Enumerable

    attr_reader :name

    def initialize(name)
      @name  = name
      @items = {}
    end

    def register(name, item)
      @items[name.to_sym] = item
    end

    def find(name)
      @items[name.to_sym]
    end

    alias :[] :find

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def registered?(name)
      @items.key?(name.to_sym)
    end

    def clear
      @items.clear
    end
  end
end
