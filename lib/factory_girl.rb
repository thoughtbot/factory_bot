require 'activesupport'
require 'factory_girl/factory'
require 'factory_girl/attribute_proxy'
require 'factory_girl/sequence'

# Shortcut for Factory.create.
#
# Example:
#   Factory(:user, :name => 'Joe')
def Factory (name, attrs = {})
  Factory.create(name, attrs)
end
