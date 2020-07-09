module FactoryBotDefinitionsHelper
  def append_file_to_factory_bot_definitions_path(path_to_file)
    FactoryBot.definition_file_paths ||= []
    FactoryBot.definition_file_paths << path_to_file
  end
end

World(FactoryBotDefinitionsHelper)

When(/^"([^"]*)" is added to FactoryBot's file definitions path$/) do |file_name|
  new_factory_file = File.join(expand_path("."), file_name.gsub(".rb", ""))

  append_file_to_factory_bot_definitions_path(new_factory_file)

  step %(I find definitions)
end

When(/^"([^"]*)" is added to FactoryBot's file definitions path as an absolute path$/) do |file_name|
  new_factory_file = File.expand_path(File.join(expand_path("."), file_name.gsub(".rb", "")))

  append_file_to_factory_bot_definitions_path(new_factory_file)

  step %(I find definitions)
end

When(/^I create a "([^"]*)" instance from FactoryBot$/) do |factory_name|
  FactoryBot.create(factory_name)
end

When(/^I find definitions$/) do
  FactoryBot.find_definitions
end

When(/^I reload factories$/) do
  FactoryBot.reload
end
