module FactoryBot
  # The attributes a definition declares, as reported in the
  # factory_bot.compile_factory notification payload.
  # @api private
  class AttributeList
    include Enumerable

    def initialize(attributes = [])
      @attributes = attributes
    end

    def each(&block)
      @attributes.each(&block)
    end

    def names
      map(&:name)
    end

    def associations
      AttributeList.new(select(&:association?))
    end

    def transient
      AttributeList.new(select(&:transient))
    end

    def non_transient
      AttributeList.new(reject(&:transient))
    end
  end
end
