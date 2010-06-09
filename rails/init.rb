require 'factory_girl'
Rails.configuration.after_initialize { Factory.find_definitions }
