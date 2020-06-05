require "active_support/core_ext/hash/indifferent_access"

module FactoryBot
  class Registry
    include Enumerable

    attr_reader :name

    def initialize(name)
      @name = name
      @items = ActiveSupport::HashWithIndifferentAccess.new
    end

    def clear
      @items.clear
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def find(name)
      @items.fetch(name)
    rescue KeyError => e
      raise key_error_with_custom_message(e)
    end

    alias [] find

    def register(name, item)
      @items[name] = item
    end

    def registered?(name)
      @items.key?(name)
    end

    private

    def key_error_with_custom_message(key_error)
      message = key_error.message.sub("key not found", "#{@name} not registered")
      error = KeyError.new(message)
      error.set_backtrace(key_error.backtrace)
      error
    end
  end
end
