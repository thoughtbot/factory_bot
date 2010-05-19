require 'factory_girl'

class Factory
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      config.after_initialize do
        Factory::Railtie.configure
      end
    end
  end

  class Railtie
    def self.configure
      Factory.definition_file_paths = [
        File.join(Rails.root, 'test', 'factories'),
        File.join(Rails.root, 'spec', 'factories')
      ]
      Factory.find_definitions
    end
  end
end
