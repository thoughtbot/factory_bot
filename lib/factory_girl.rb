require 'active_support'
require 'factory_girl/factory'
require 'factory_girl/attribute_proxy'
require 'factory_girl/attribute'
require 'factory_girl/sequence'
require 'factory_girl/aliases'

# Shortcut for Factory.create.
#
# Example:
#   Factory(:user, :name => 'Joe')
def Factory (name, attrs = {})
  Factory.create(name, attrs)
end

if defined? Rails
  Rails.configuration.after_initialize do
    Factory.definition_file_paths = [
      File.join(RAILS_ROOT, 'test', 'factories'),
      File.join(RAILS_ROOT, 'spec', 'factories')
    ]
    Factory.find_definitions
  end
else
  Factory.find_definitions
end

