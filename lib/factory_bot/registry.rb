require "active_support/hash_with_indifferent_access"

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

    alias_method :[], :find

    def register(name, item)
      @items[name] = item
    end

    def registered?(name)
      @items.key?(name)
    end

    private

    def key_error_with_custom_message(key_error)
      message = key_error.message.sub("key not found", "#{@name} not registered")
      KeyError.new(message, key: key_error.key, receiver: key_error.receiver).tap do |error|
        error.set_backtrace(key_error.backtrace)
      end
    end
  end
end
