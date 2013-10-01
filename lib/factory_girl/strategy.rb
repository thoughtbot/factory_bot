module FactoryGirl
  class Strategy

    autoload :Build, 'factory_girl/strategy/build'
    autoload :Create, 'factory_girl/strategy/create'
    autoload :AttributesFor, 'factory_girl/strategy/attributes_for'
    autoload :Stub, 'factory_girl/strategy/stub'
    autoload :Null, 'factory_girl/strategy/null'

  end
end