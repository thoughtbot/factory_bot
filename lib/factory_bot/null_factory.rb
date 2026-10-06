module FactoryBot
  # @api private
  class NullFactory
    attr_reader :definition

    def initialize
      @definition = Definition.new(:null_factory)
    end

    def parent
    end

    def build_class
    end

    def class_name
    end

    def compiled(_trait_names = [])
      Internal.compiled_configuration
    end
  end
end
