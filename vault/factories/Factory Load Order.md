---
type: note
created: 2026-03-06T14:36:02-06:00
updated: 2026-03-06T14:53:36-06:00
tags: []
aliases: []
---
# Factory Load Order

## Finding and Loading Factory Definitions

The `FactoryBot.find_definitions` method loads in all factory\_bot definitions
across the project.

## Default Load Order

The load order is controlled by the `FactoryBot.definition_file_paths` attribute.

The default load order is:

1. `factories.rb`
1. `factories/**/*.rb`
1. `test/factories.rb`
1. `test/factories/**/*.rb`
1. `spec/factories.rb`
1. `spec/factories/**/*.rb`

## Automatic Factory Loading in Rails

When using FactoryBot with Ruby on Rails via `factory_bot-rails`, the `FactoryBot.find_definitions` method is called automatically after the application initializes.

The `FactoryBot.definition_file_paths` can be set during initialization (e.g. `config/initializers`), or via `Rails.application.config.factory_bot.definition_file_paths`.

## Related

Refer to [[Factory Definition File Paths]] for more information on loading factories
