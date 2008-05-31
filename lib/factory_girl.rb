require 'activesupport'
require 'factory_girl/factory'

# Shortcut for Factory.create.
#
# Example:
#   Factory(:user, :name => 'Joe')
def Factory (name, attrs = {})
  Factory.create(name, attrs)
end
