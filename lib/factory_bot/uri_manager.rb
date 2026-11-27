module FactoryBot
  # @api private
  module UriManager
    # Concatenate the parts, stripping leading/following slashes
    # and returning a Symbolized String or nil.
    #
    # Example:
    #   build_uri(:my_factory, :my_trait, :my_sequence)
    #   #=> :"myfactory/my_trait/my_sequence"
    #
    def self.build_uri(*parts)
      return nil if parts.empty?

      parts.join("/")
        .sub(/\A\/+/, "")
        .sub(/\/+\z/, "")
        .tr(" ", "_")
        .to_sym
    end

    # One URI per endpoint, or per path and endpoint pair when paths are given.
    def self.build_uris(endpoints, paths = [])
      paths = Array(paths).flatten

      Array(endpoints).flatten.flat_map do |endpoint|
        if paths.any?
          paths.map { |path| build_uri(path, endpoint) }
        else
          [build_uri(endpoint)]
        end
      end
    end
  end
end
