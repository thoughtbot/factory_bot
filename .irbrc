def reload!
  # Undefine FactoryBot so we can reload Constants and fresh code
  Object.send(:remove_const, :FactoryBot) if Object.const_defined?(:FactoryBot)

  # Remove all files from the 'loaded' register
  $LOADED_FEATURES.grep(/factory_bot/).each do |path|
    $LOADED_FEATURES.delete(path)
  end

  # re-load it again
  require "factory_bot"
  puts "\nfactory_bot reloaded!\n\n"
  true
end
