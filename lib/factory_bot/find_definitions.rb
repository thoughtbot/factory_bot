module FactoryBot
  class << self
    # An Array of strings specifying locations that should be searched for
    # factory definitions. By default, factory_bot will attempt to require
    # "factories.rb", "factories/**/*.rb", "test/factories.rb",
    # "test/factories/**.rb", "spec/factories.rb", and "spec/factories/**.rb".
    attr_accessor :definition_file_paths
  end

  self.definition_file_paths = %w[factories test/factories spec/factories]

  # Loads in all factory\_bot definitions across the project. The load order is
  # controlled by the `FactoryBot.definition_file_paths` attribute.
  #
  # The default load order is:
  # 1. `factories.rb`
  # 1. `factories/**/*.rb`
  # 1. `test/factories.rb`
  # 1. `test/factories/**/*.rb`
  # 1. `spec/factories.rb`
  # 1. `spec/factories/**/*.rb`
  def self.find_definitions
    absolute_definition_file_paths = definition_file_paths.map { |path| File.expand_path(path) }

    absolute_definition_file_paths.uniq.each do |path|
      load("#{path}.rb") if File.exist?("#{path}.rb")

      if File.directory? path
        Dir[File.join(path, "**", "*.rb")].sort.each do |file|
          load file
        end
      end
    end
  end
end
