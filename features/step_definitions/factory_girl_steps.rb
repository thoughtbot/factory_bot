When /^"([^"]*)" is added to Factory Girl's file definitions path$/ do |file_name|
  new_factory_file = File.join(current_dir, file_name.gsub(".rb", ""))
  FactoryGirl.definition_file_paths ||= []
  FactoryGirl.definition_file_paths << new_factory_file
  FactoryGirl.find_definitions
end

When /^I create a "([^"]*)" instance from Factory Girl$/ do |factory_name|
  FactoryGirl.create(factory_name)
end
