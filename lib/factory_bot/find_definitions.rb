module FactoryBot
  # Extended into FactoryBot. Loads factory files from definition_file_paths.
  module FindDefinitions
    attr_writer :definition_file_paths

    def definition_file_paths
      @definition_file_paths ||= %w[factories test/factories spec/factories]
    end

    def find_definitions
      definition_file_paths.map { |path| File.expand_path(path) }.uniq.each do |path|
        load("#{path}.rb") if File.exist?("#{path}.rb")

        if File.directory?(path)
          Dir[File.join(path, "**", "*.rb")].sort.each { |file| load(file) }
        end
      end
    end

    def reload
      reset_configuration
      register_default_strategies
      find_definitions
    end
  end
end
