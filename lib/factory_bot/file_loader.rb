require "tempfile"

module FactoryBot
  class FileLoader
    attr_reader :tempfile, :original_filename

    def initialize(file_path)
      from_file_path(file_path)
    end

    def method_missing(method_name, *args, &block) # rubocop:disable Style/MethodMissing
      tempfile.public_send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      tempfile.respond_to?(method_name, include_private) || super
    end

    def io
      tempfile.read
    end

    private

    def from_file_path(path)
      raise FileDoesNotExistError unless ::File.exist?(path)

      @original_filename = ::File.basename(path)
      extension = ::File.extname(@original_filename)

      @tempfile = Tempfile.new(
        [::File.basename(@original_filename, extension), extension],
      )
      @tempfile.set_encoding(Encoding::BINARY) if @tempfile.respond_to?(:set_encoding)

      FileUtils.copy_file(path, @tempfile.path)
    end
  end
end
