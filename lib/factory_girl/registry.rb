module FactoryGirl
  class Registry
    include Enumerable

    attr_reader :name

    def initialize(name)
      @name  = name
      @items = {}
    end

    def clear
      @items.clear
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def find(name)
      if registered?(name)
        @items[name.to_sym]
      else
        raise ArgumentError, "#{@name} not registered: #{name}"
      end
    end

    alias :[] :find

    def register(name, item)
      @items[name.to_sym] = item
    end

    def registered?(name)
      @items.key?(name.to_sym)
    end
  end
end
