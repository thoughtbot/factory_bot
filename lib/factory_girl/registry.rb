module FactoryGirl
  class Registry
    def initialize
      @items = {}
    end

    def add(item)
      item.names.each { |name| add_as(name, item) }
      item
    end

    def find(name)
      @items[name.to_sym] or raise ArgumentError.new("Not registered: #{name.to_s}")
    end

    def each(&block)
      @items.each(&block)
    end

    def [](name)
      find(name)
    end

    def registered?(name)
      @items.key?(name.to_sym)
    end

    private

    def add_as(name, item)
      if registered?(name)
        raise DuplicateDefinitionError, "Already defined: #{name}"
      else
        @items[name.to_sym] = item
      end
    end
  end

  def self.register(item)
    registry.add(item)
  end

  def self.registered?(name)
    registry.registered?(name)
  end

  def self.find(name)
    registry.find(name)
  end

  def self.registry
    @registry ||= Registry.new
  end

  def self.registry=(registry)
    @registry = registry
  end
end

