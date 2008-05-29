require 'factory_girl/factory'

def Factory (name, attrs = {})
  Factory.create(name, attrs)
end
