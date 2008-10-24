config.after_initialize do
  require 'factory_girl'
  Factory.definition_file_paths = [
    File.join(RAILS_ROOT, 'test', 'factories'),
    File.join(RAILS_ROOT, 'spec', 'factories')
  ]
  Factory.find_definitions
end