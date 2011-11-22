require "factory_girl/attribute/static"
require "factory_girl/attribute/dynamic"
require "factory_girl/attribute/association"
require "factory_girl/attribute/sequence"

module FactoryGirl

  class Attribute #:nodoc:
    attr_reader :name, :ignored

    def initialize(name, ignored)
      @name = name.to_sym
      @ignored = ignored
      ensure_non_attribute_writer!
    end

    def add_to(proxy)
      if @ignored
        proxy.set_ignored(self, to_proc(proxy))
      else
        proxy.set(self, to_proc(proxy))
      end
    end

    def to_proc(proxy)
      lambda { }
    end

    def association?
      false
    end

    def alias_for?(attr)
      FactoryGirl.aliases_for(attr).include?(name)
    end

    private

    def ensure_non_attribute_writer!
      if @name.to_s =~ /=$/
        attribute_name = $`
        raise AttributeDefinitionError,
          "factory_girl uses 'f.#{attribute_name} value' syntax " +
          "rather than 'f.#{attribute_name} = value'"
      end
    end
  end
end
