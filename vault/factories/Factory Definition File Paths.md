---
type: note
created: 2025-11-08T18:36:43-06:00
updated: 2025-11-08T18:54:13-06:00
tags: []
aliases: []
---
# Factory Definition File Paths

Factories can be defined anywhere, but will be automatically loaded after calling `FactoryBot.find_definitions` if factories are defined in files at the following locations:

```text
factories.rb
factories/**/*.rb
test/factories.rb
test/factories/**/*.rb
spec/factories.rb
spec/factories/**/*.rb
```

## Default Load Order

The list above also illustrates the default load order of factories. FactoryBot will first load the factories file, followed by the factories directory, and so on.

## Loading Factories

The `FactoryBot.find_definitions` method loads in all factory\_bot definitions
across the project. 

## Customizing the File Paths or Load Order

The file paths and/or load order may be customized by altering the `FactoryBot.definition_file_paths` configuration before loading factories
