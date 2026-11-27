require "active_support/hash_with_indifferent_access"

module FactoryBot
  class Registry
    include Enumerable

    attr_reader :name

    def initialize(name, replace: true)
      @name = name
      @replace = replace
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
      if !@replace && registered?(name)
        raise DuplicateDefinitionError, "#{@name} already registered: #{name}"
      end

      @items[name] = item
    end

    def register_all(names, item)
      registered = []
      names.each do |name|
        register(name, item)
        registered << name
      end
      item
    rescue DuplicateDefinitionError
      # A rejected name must not leave the item reachable by its other names.
      registered.each { |name| @items.delete(name) }
      raise
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
