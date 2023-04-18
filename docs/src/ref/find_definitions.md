# FactoryBot.find_definitions

The `FactoryBot.find_definitions` method loads in all factory\_bot definitions
across the project.

The load order is controlled by the `FactoryBot.definition_file_paths`
attribute. The default load order is:

1. `factories.rb`
1. `test/factories.rb`
1. `test/factories/**/*.rb`
1. `spec/factories.rb`
1. `spec/factories/**/*.rb`

## Rails

The `.find_definitions` method is called automatically by `factory_bot_rails`
after initialize. The `.definition_file_paths` can be set during initialization
(e.g. `config/initializers`), or via
`Rails.application.config.factory_bot.definition_file_paths`.
