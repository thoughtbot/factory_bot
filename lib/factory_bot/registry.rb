module FactoryBot
  # Name-keyed store for factories, sequences, traits and strategies. Keys are
  # compared by their String form, so :user and "user" address the same item.
  class Registry
    include Enumerable

    def initialize(kind)
      @kind = kind
      @items = {}
    end

    def register(name, item, replace: false)
      key = name.to_s

      if !replace && @items.key?(key)
        raise DuplicateDefinitionError, "#{@kind} already registered: #{name}"
      end

      @items[key] = item
    end

    def find(name)
      key = name.to_s

      @items.fetch(key) do
        shown = name.is_a?(Symbol) ? key : name
        raise KeyError.new("#{@kind} not registered: #{shown.inspect}", receiver: @items, key: key)
      end
    end

    alias_method :[], :find

    def registered?(name)
      @items.key?(name.to_s)
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def clear
      @items.clear
    end
  end
end
