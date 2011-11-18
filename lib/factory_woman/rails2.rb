Rails.configuration.after_initialize do
  FactoryWoman.definition_file_paths = [
    File.join(Rails.root, 'factories'),
    File.join(Rails.root, 'test', 'factories'),
    File.join(Rails.root, 'spec', 'factories')
  ]
  FactoryWoman.find_definitions
end
