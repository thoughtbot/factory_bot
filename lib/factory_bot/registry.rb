require "active_support/core_ext/hash/indifferent_access"

module FactoryBot
  class Registry
    include Enumerable

    attr_reader :name

    def initialize(name)
      @name  = name
      @items = ActiveSupport::HashWithIndifferentAccess.new
    end

    def clear
      @items.clear
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def find(name)
      with_custom_key_error("#{@name} not registered: #{name}") { @items.fetch(name) }
    end

    alias :[] :find

    def register(name, item)
      @items[name] = item
    end

    def registered?(name)
      @items.key?(name)
    end

    private

    def with_custom_key_error(message)
      yield
    rescue KeyError => e
      error = KeyError.new(message)
      error.set_backtrace(e.backtrace)
      raise error
    end
  end
end
