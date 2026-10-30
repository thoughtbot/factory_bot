def reload!
  # Undefine FactoryBot so we can reload constants and fresh code
  Object.send(:remove_const, :FactoryBot) if Object.const_defined?(:FactoryBot)

  # Remove all files from the 'loaded' register
  $LOADED_FEATURES.delete_if { |path| path.match?(/factory_bot/) }

  # re-load it again
  require "factory_bot"
  puts "\nfactory_bot reloaded!\n\n"
  true
end
