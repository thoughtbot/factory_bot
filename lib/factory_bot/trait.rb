module FactoryBot
  # @api private
  class Trait
    attr_reader :name, :definition

    def initialize(name, **options, &block)
      @name = name.to_s
      @block = block
      uri_paths = FactoryBot::UriManager.build_uris(names, options[:uri_paths])

      @definition = Definition.new(@name, uri_paths: uri_paths)
      proxy = FactoryBot::DefinitionProxy.new(@definition)

      if block
        proxy.instance_eval(&@block)
      end
    end

    def names
      [@name]
    end

    def ==(other)
      name == other.name &&
        block == other.block
    end

    protected

    attr_reader :block
  end
end
